extends CharacterBody2D

# ── Preloads ──
const ITEM_PICKUP_SCENE = preload("res://custom_nodes/ItemPickUp/ItemPickup.tscn")
const ARROW_SCENE = preload("res://custom_nodes/boxes/arrow.tscn")
const ESCAPEMENU_SCENE = preload("res://scenes/EscapeMenu/EscapeMenu.tscn")

# ── Movement ──
const RUN_SPEED = 350
const ACCELERATION = 2500.0
const DECELERATION = 3000.0
const AIR_MULT = 0.65

# ── Jump ──
const JUMP_FORCE = -750
const GRAVITY = 3000
const JUMP_CUT_GRAVITY = 6000
const MAX_JUMP_TIME = 0.2
const FALL_GRAVITY_MULT = 1.6
const COYOTE_TIME = 0.1
const JUMP_BUFFER_TIME = 0.1

# ── Combat ──
const MAX_COMBO = 3
const COMBO_RESET_TIME = 0.35
const MELEE_HIT_WINDOW = 0.2
const RANGED_COOLDOWN = 0.4

# ── Node refs ──
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_pivot: Node2D = $AttackPivot
@onready var hitbox: Hitbox = $AttackPivot/MeleeHitbox
@onready var hitbox_shape: CollisionShape2D = $AttackPivot/MeleeHitbox/CollisionShape2D
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var escape_menu = ESCAPEMENU_SCENE.instantiate()
@onready var inventory: Inventory = SaveManager.inventory

# ── State ──
var save: PlayerSaveFile
var facing_right := true

# Jump
var is_jumping := false
var jump_timer := 0.0
var coyote_timer := 0.0
var jump_buffer_timer := 0.0

# Combat
var is_attacking := false
var combo_count := 0
var combo_queued := false
var combo_reset_timer := 0.0
var ranged_cooldown := 0.0

# UI / dialogue
var is_inui := false
var is_in_dialogue := false

signal pause


# ──────────────────────────────────────────────────────────
#  Lifecycle
# ──────────────────────────────────────────────────────────
func _ready() -> void:
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


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	if not is_inui:
		_handle_jump(delta)
	_handle_movement(delta)
	_handle_attack(delta)
	_update_hitbox_facing()
	_update_animation()
	move_and_slide()
	_handle_escape()


# ──────────────────────────────────────────────────────────
#  Movement / Jump / Gravity
# ──────────────────────────────────────────────────────────
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
		is_jumping = true
		jump_timer = 0.0
		coyote_timer = 0.0
		jump_buffer_timer = 0.0
	
	if is_jumping:
		jump_timer += delta
		if jump_timer >= MAX_JUMP_TIME:
			is_jumping = false


# ──────────────────────────────────────────────────────────
#  Combat
# ──────────────────────────────────────────────────────────
func _handle_attack(delta: float) -> void:
	if combo_reset_timer > 0.0:
		combo_reset_timer -= delta
		if combo_reset_timer <= 0.0:
			combo_count = 0
	
	ranged_cooldown = max(0.0, ranged_cooldown - delta)
	
	if Input.is_action_just_pressed("right_click"):
		print("RMB! cooldown=", ranged_cooldown, " is_attacking=", is_attacking, " is_inui=", is_inui, " is_in_dialogue=", is_in_dialogue)
	
	if is_inui or is_in_dialogue or _any_ui_open():
		return
	
	if Input.is_action_just_pressed("left_click"):
		if not is_attacking:
			_start_melee_attack()
		elif combo_count < MAX_COMBO:
			combo_queued = true
	
	if Input.is_action_just_pressed("right_click") and ranged_cooldown <= 0 and not is_attacking:
		_start_ranged_attack()

func _start_ranged_attack() -> void:
	ranged_cooldown = RANGED_COOLDOWN
	sprite.play("hit")
	
	var arrow = ARROW_SCENE.instantiate()
	get_tree().current_scene.add_child(arrow)
	# Pfeil spawnt 40px vor dem Player, nicht im Player drin
	var offset = Vector2(40 if facing_right else -40, 0)
	arrow.global_position = global_position + offset
	arrow.direction = Vector2.RIGHT if facing_right else Vector2.LEFT
	if arrow.has_node("Sprite2D"):
		arrow.get_node("Sprite2D").flip_h = not facing_right
		
func _any_ui_open() -> bool:
	if has_node("ZeitmaschinenUI") and $ZeitmaschinenUI.visible:
		return true
	return false


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

# ──────────────────────────────────────────────────────────
#  Damage / Heal
# ──────────────────────────────────────────────────────────
func take_damage(damage: int) -> void:
	save.hp -= damage
	print("Player HP: ", save.hp)
	SaveManager.save_all(0)
	if save.hp <= 0:
		_die()


func heal(amount: int) -> void:
	save.hp = min(save.hp + amount, save.max_hp)
	SaveManager.save_all(0)


func _on_hurt(damage: int, knockback: Vector2) -> void:
	take_damage(damage)
	velocity += knockback


func _die() -> void:
	print("Player ist gestorben")
	# TODO: death anim, game over, respawn


# ──────────────────────────────────────────────────────────
#  Animation
# ──────────────────────────────────────────────────────────
func _update_animation() -> void:
	if is_attacking:
		return
	if not is_on_floor():
		sprite.play("jump")
	elif velocity.x != 0:
		sprite.play("run")
	else:
		sprite.play("idle")


# ──────────────────────────────────────────────────────────
#  Items / Pickup
# ──────────────────────────────────────────────────────────
func _on_item_dropped(item: Item) -> void:
	var pickup = ITEM_PICKUP_SCENE.instantiate()
	pickup.item = item
	get_parent().add_child(pickup)
	pickup.global_position = global_position
	pickup.disable_pickup_temporarily(0.5)


# ──────────────────────────────────────────────────────────
#  Misc
# ──────────────────────────────────────────────────────────
func bounce(force: float) -> void:
	velocity.y = force
	is_jumping = false
	jump_timer = 0.0
	coyote_timer = 0.0


func enterlevel() -> void:
	$LevelTimer.wait_time = SaveManager.player.level_time
	$LevelTimer.start()


func _on_level_timer_timeout() -> void:
	print("Level Vorbei")


func _on_timer_timeout() -> void:
	SaveManager.save_all(0)


# ──────────────────────────────────────────────────────────
#  UI / Escape
# ──────────────────────────────────────────────────────────
func _handle_escape() -> void:
	if Input.is_action_just_pressed("phone"):
		$PhoneUI.visible = not $PhoneUI.visible
		is_inui = $PhoneUI.visible
	if Input.is_action_just_pressed("escape"):
		pause.emit()
		if get_tree().paused:
			escape_menu.hide_menu()
		else:
			escape_menu.show_menu()


# ──────────────────────────────────────────────────────────
#  Dialogue
# ──────────────────────────────────────────────────────────
func _on_dmitri_dialogue_started() -> void:
	is_in_dialogue = true


func _on_dmitri_dialogue_ended() -> void:
	is_in_dialogue = false
