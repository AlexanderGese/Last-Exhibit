extends CharacterBody2D

const ITEM_PICKUP_SCENE = preload("res://custom_nodes/ItemPickUp/ItemPickup.tscn")
const ARROW_SCENE = preload("res://custom_nodes/boxes/arrow.tscn")
const BUlLET_PISTOL_SCENE = preload("res://custom_nodes/boxes/bullet_pistol.tscn")
const BULLET_GUN_SCENE = preload("res://custom_nodes/boxes/bullet_gun.tscn")
const ESCAPEMENU_SCENE = preload("res://scenes/EscapeMenu/EscapeMenu.tscn")

const RUN_SPEED = 350
const ACCELERATION = 2500.0
const DECELERATION = 3000.0
const AIR_MULT = 0.65

const JUMP_FORCE = -750
const GRAVITY = 3000
const JUMP_CUT_GRAVITY = 6000
const MAX_JUMP_TIME = 0.2
const FALL_GRAVITY_MULT = 1.6
const COYOTE_TIME = 0.1
const JUMP_BUFFER_TIME = 0.1

const MAX_COMBO = 3
const COMBO_RESET_TIME = 0.35
const MELEE_HIT_WINDOW = 0.2
const RANGED_COOLDOWN = 0.4
const RANGED_ANIM_LOCK = 0.3

const CLIMB_SPEED = 180.0

const HURT_FLASH_COLOR := Color(2.5, 0.3, 0.3, 1)
const ORIGINAL_MODULATE := Color.WHITE
const INVINCIBILITY_DURATION := 0.5
const MAX_RESISTANCE := 0.9

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_pivot: Node2D = $AttackPivot
@onready var hitbox: Hitbox = $AttackPivot/MeleeHitbox
@onready var hitbox_shape: CollisionShape2D = $AttackPivot/MeleeHitbox/CollisionShape2D
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var escape_menu = ESCAPEMENU_SCENE.instantiate()
@onready var inventory: Inventory = SaveManager.inventory
@onready var level_timer: Timer = $LevelTimer
@onready var phone_ui = $PhoneUI
@onready var zeitmaschine = $ZeitmaschinenUI

var save: PlayerSaveFile
var facing_right := true

var is_jumping := false
var jump_timer := 0.0
var coyote_timer := 0.0
var jump_buffer_timer := 0.0

var is_attacking := false
var combo_count := 0
var combo_queued := false
var combo_reset_timer := 0.0
var ranged_cooldown := 0.0
var anim_locked_until := 0.0

var ranged_animation: String = ""
enum equiped {NONE, GUN, PISTOL}
var current_bullet_scene: PackedScene = null
var current_gun: equiped
var dev_override: bool = false


var is_climbing := false
var ladders: Array = []         
var climb_ladder = null          
var in_emtpy_showcase: bool = false

var is_inui := false
var is_in_dialogue := false

var flash_tween: Tween = null
var is_invincible: bool = false


signal pause


func _ready() -> void:
	Events.weapon_changed.connect(weapon_change)
	Events.dialogue_started.connect(_on_dialogue_started)
	Events.dialogue_ended.connect(_on_dialogue_ended)
	add_child(escape_menu)
	save = SaveManager.player
	$Timer.start()
	add_to_group("player")
	sprite.animation_finished.connect(_on_animation_finished)
	hurtbox.hurt.connect(_on_hurt)
	SaveManager.item_dropped.connect(_on_item_dropped)
	hitbox_shape.disabled = true
	if inventory == null:
		push_error("Player: kein Inventory zugewiesen!")

	var equipped_weapon = SaveManager.inventory.equipped.get("weapon")
	if equipped_weapon:
		weapon_change(equipped_weapon.id)
	if Events.in_level:
		enterlevel()
		Tutorials.show_tutorial("levels")


func _physics_process(delta: float) -> void:
	anim_locked_until = max(0.0, anim_locked_until - delta)
	SaveManager.player.playertiner = level_timer.get_time_left()
	if is_climbing:
		_handle_climb(delta)
		_update_animation()
		move_and_slide()
		_handle_escape()
		return
	
	_apply_gravity(delta)
	if not is_inui:
		_handle_jump(delta)
	_handle_movement(delta)
	_handle_attack(delta)
	_check_climb_start()
	_update_hitbox_facing()
	_update_animation()
	move_and_slide()
	_handle_escape()



func _apply_gravity(delta: float) -> void:

	if is_on_floor():
		return
	var grav := float(GRAVITY)
	if velocity.y > 0:
		grav *= FALL_GRAVITY_MULT
	if is_jumping and not Input.is_action_pressed("jump"):
		grav = JUMP_CUT_GRAVITY
		is_jumping = false
	velocity.y += grav * delta


func _handle_movement(delta: float) -> void:
	if is_attacking:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
		return
	
	var direction := Input.get_axis("left", "right")
	var mult := 1.0 if is_on_floor() else AIR_MULT
	
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * RUN_SPEED, ACCELERATION * mult * delta)
		facing_right = direction > 0
		sprite.flip_h = not facing_right
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * mult * delta)


func _handle_jump(delta: float) -> void:
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta
	
	if Input.is_action_just_pressed("jump"):
		if is_in_dialogue:
			return
		jump_buffer_timer = JUMP_BUFFER_TIME
	else:
		jump_buffer_timer -= delta
	
	if jump_buffer_timer > 0.0 and coyote_timer > 0.0:
		velocity.y = JUMP_FORCE
		Effects.play("jump")
		is_jumping = true
		jump_timer = 0.0
		coyote_timer = 0.0
		jump_buffer_timer = 0.0
	
	if is_jumping:
		jump_timer += delta
		if jump_timer >= MAX_JUMP_TIME:
			is_jumping = false


func _check_climb_start() -> void:
	if is_climbing or ladders.is_empty():
		return
	if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down"):
		_start_climbing()


func _start_climbing() -> void:
	is_climbing = true
	is_jumping = false
	climb_ladder = _nearest_ladder()
	velocity = Vector2.ZERO
	if climb_ladder:
		global_position.x = climb_ladder.climb_x()
	sprite.play("climb")


func _stop_climbing() -> void:
	is_climbing = false
	climb_ladder = null


func _handle_climb(_delta: float) -> void:
	if ladders.is_empty():
		_stop_climbing()
		return

	if Input.is_action_just_pressed("jump"):
		_stop_climbing()
		velocity.y = JUMP_FORCE * 0.7
		is_jumping = true
		jump_timer = 0.0
		return

	var v := Input.get_axis("up", "down")
	velocity.y = v * CLIMB_SPEED
	velocity.x = 0.0

	if climb_ladder:
		global_position.x = climb_ladder.climb_x()

	if is_on_floor() and v >= 0.0:
		_stop_climbing()


func _nearest_ladder():
	var best = null
	var best_dist := INF
	for l in ladders:
		var d: float = absf(l.climb_x() - global_position.x)
		if d < best_dist:
			best_dist = d
			best = l
	return best


func enter_ladder(ladder) -> void:
	if not ladders.has(ladder):
		ladders.append(ladder)


func exit_ladder(ladder) -> void:
	ladders.erase(ladder)
	if ladders.is_empty():
		if is_climbing:
			_stop_climbing()
	elif ladder == climb_ladder:
		climb_ladder = ladders.back()  


func _handle_attack(delta: float) -> void:
	if combo_reset_timer > 0.0:
		combo_reset_timer -= delta
		if combo_reset_timer <= 0.0:
			combo_count = 0
	
	ranged_cooldown = max(0.0, ranged_cooldown - delta)
	
	if is_inui or is_in_dialogue or _any_ui_open():
		return
	
	if Input.is_action_just_pressed("left_click"):
		if not is_attacking:
			_start_melee_attack()
		elif combo_count < MAX_COMBO:
			combo_queued = true
	
	if Input.is_action_just_pressed("right_click") and ranged_cooldown <= 0 and not is_attacking:
		_start_ranged_attack()


func _start_melee_attack() -> void:
	is_attacking = true
	combo_count += 1
	combo_queued = false
	combo_reset_timer = 0.0
	sprite.play("hit")
	_activate_hitbox()


func _activate_hitbox() -> void:
	hitbox_shape.disabled = false
	await get_tree().create_timer(MELEE_HIT_WINDOW).timeout
	hitbox_shape.disabled = true

func weapon_change(type: String) -> void:
	match type:
		"gun":
			ranged_animation = "shoot_gun"
			current_bullet_scene = BULLET_GUN_SCENE
			current_gun = equiped.GUN
		"pistol":
			ranged_animation = "shoot_pistol"
			current_bullet_scene = BUlLET_PISTOL_SCENE
			current_gun = equiped.PISTOL
		_:
			ranged_animation = ""
			current_bullet_scene = null
			current_gun = equiped.NONE


func _start_ranged_attack() -> void:
	if current_gun == equiped.NONE and not dev_override:
		return
	if dev_override:
		current_bullet_scene = BULLET_GUN_SCENE
		ranged_animation = "shoot_gun"
	ranged_cooldown = RANGED_COOLDOWN
	sprite.play(ranged_animation)
	Effects.play(ranged_animation)
	anim_locked_until = RANGED_ANIM_LOCK
	var scene: PackedScene = current_bullet_scene if current_bullet_scene else ARROW_SCENE
	var arrow = scene.instantiate()
	get_tree().current_scene.add_child(arrow)
	var offset := Vector2(40 if facing_right else -40, -10)
	arrow.global_position = global_position + offset
	arrow.direction = Vector2.RIGHT if facing_right else Vector2.LEFT
	if arrow.has_node("Sprite2D"):
		arrow.get_node("Sprite2D").flip_h = not facing_right



func set_ranged_weapon(animation_name: String) -> void:
	ranged_animation = animation_name


func _any_ui_open() -> bool:
	return zeitmaschine.visible


func _on_animation_finished() -> void:
	if sprite.animation != "hit":
		return
	if combo_queued and combo_count < MAX_COMBO:
		_start_melee_attack()
	else:
		is_attacking = false
		combo_queued = false
		combo_reset_timer = COMBO_RESET_TIME


func _update_hitbox_facing() -> void:
	attack_pivot.scale.x = 1 if facing_right else -1

func getHP() -> int:
	return int(save.hp)
	

func armor_resistance() -> float:
	var total := 0.0
	for key in ["head", "body", "legs", "feet"]:
		var piece = SaveManager.inventory.equipped.get(key)
		if piece:
			total += piece.resistance
	return min(total, MAX_RESISTANCE)


func take_damage(damage: int) -> void:
	var resist := armor_resistance()
	var reduced: int = int(round(damage * (1.0 - resist)))
	save.hp -= reduced
	if save.hp <= 0:
		_die()


func heal(amount: int) -> bool:
	if save.hp == save.max_hp:
		return false
	save.hp = min(save.hp + amount, save.max_hp)
	return true

func _on_hurt(damage: int, knockback: Vector2) -> void:
	if is_invincible:
		return
	take_damage(damage)
	velocity += knockback
	_play_hurt_flash()
	_start_invincibility(INVINCIBILITY_DURATION)


func _play_hurt_flash() -> void:
	if flash_tween and flash_tween.is_valid():
		flash_tween.kill()
	
	sprite.modulate = HURT_FLASH_COLOR
	flash_tween = create_tween()
	flash_tween.tween_interval(0.1)
	flash_tween.tween_property(sprite, "modulate", ORIGINAL_MODULATE, 0.2)


func _start_invincibility(duration: float) -> void:
	if save.hp <= 0:
		return
	is_invincible = true
	await get_tree().create_timer(duration).timeout
	if is_instance_valid(self):
		is_invincible = false


func _die() -> void:
	print("Player ist gestorben")
	
	if flash_tween and flash_tween.is_valid():
		flash_tween.kill()
	sprite.modulate = ORIGINAL_MODULATE

	Events.in_level = false
	level_timer.stop()
	SaveManager.clear_inventory()
	save.hp = save.max_hp
	SaveManager.save_all()
	await Fader.fade_out(1.0)
	get_tree().change_scene_to_file("res://scenes/Museum/Museum.tscn")


func _update_animation() -> void:
	if is_attacking or anim_locked_until > 0:
		return
	
	if is_climbing:
		if abs(velocity.y) > 0.1:
			if sprite.animation != "climb" or not sprite.is_playing():
				sprite.play("climb")
		else:
			if sprite.animation != "climb":
				sprite.play("climb")
			sprite.pause()
		return
	
	if not is_on_floor():
		if sprite.animation != "jump":
			sprite.play("jump")
	elif velocity.x != 0:
		if sprite.animation != "walk":
			sprite.play("walk")
	else:
		if sprite.animation != "idle":
			sprite.play("idle")


func _on_item_dropped(item: Item) -> void:
	var pickup = ITEM_PICKUP_SCENE.instantiate()
	pickup.item = item
	get_parent().add_child(pickup)
	pickup.global_position = global_position
	pickup.disable_pickup_temporarily(0.5)


func bounce(force: float) -> void:
	velocity.y = force
	is_jumping = false
	jump_timer = 0.0
	coyote_timer = 0.0


func enterlevel() -> void:
	level_timer.start(SaveManager.player.level_time)



func _on_level_timer_timeout() -> void:
	Events.in_level = false
	Events.end_level.emit()
	SaveManager.advance_day()
	get_tree().change_scene_to_file("res://scenes/Museum/Museum.tscn")


func _on_timer_timeout() -> void:
	SaveManager.save_all()


func _handle_escape() -> void:
	if Input.is_action_just_pressed("phone"):
		phone_ui.visible = not phone_ui.visible
		is_inui = phone_ui.visible
	if Input.is_action_just_pressed("escape"):
		pause.emit()
		if get_tree().paused:
			escape_menu.hide_menu()
		else:
			escape_menu.show_menu()


func _on_dialogue_started() -> void:
	is_in_dialogue = true
	
func _on_dialogue_ended() -> void:
	is_in_dialogue  = false
