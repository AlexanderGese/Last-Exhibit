extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox_shape: CollisionShape2D = $HitBox/CollisionShape2D
@onready var hitbox_node: Area2D = $HitBox
@onready var ESCAPEMENUINSTANCE = preload("res://scenes/EscapeMenu/EscapeMenu.tscn").instantiate()
@onready var inventory: Inventory = SaveManager.inventory

const ITEM_PICKUP_SCENE = preload("res://custom_nodes/ItemPickUp/ItemPickup.tscn")
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
const HITSTOP_TIME = 0.04
const ATTACK_SLIDE = 120.0

var save: PlayerSaveFile
var save_achiev: AchievmentSaveFile
var facing_right := true

# Jump state
var is_jumping := false
var jump_timer := 0.0
var coyote_timer := 0.0
var jump_buffer_timer := 0.0

# Combat state
var is_attacking := false
var combo_count := 0
var combo_queued := false
var combo_reset_timer := 0.0

func _ready():
	add_child(ESCAPEMENUINSTANCE)
	save = SaveManager.player
	$Timer.start()
	add_to_group("player")
	sprite.animation_finished.connect(_on_animation_finished)
	if inventory == null:
		push_error("Player: kein Inventory zugewiesen!")
	SaveManager.item_dropped.connect(_on_item_dropped)


func _on_item_dropped(item: Item) -> void:
	var pickup := ITEM_PICKUP_SCENE.instantiate()
	pickup.item = item
	var parent := get_parent()
	parent.add_child(pickup)
	pickup.global_position = global_position
	pickup.disable_pickup_temporarily(0.5)

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_handle_jump(delta)
	_handle_movement(delta)
	_handle_attack(delta)
	_update_animation()
	move_and_slide()
	_handle_escape()

# ── Gravity ──

func _apply_gravity(delta: float) -> void:
	if is_on_floor():
		return
	var grav := GRAVITY
	if velocity.y > 0:
		grav *= FALL_GRAVITY_MULT
	if is_jumping and not Input.is_action_pressed("jump"):
		grav = JUMP_CUT_GRAVITY
		is_jumping = false
	velocity.y += grav * delta

# ── Movement ──

func _handle_movement(delta: float) -> void:
	var direction := Input.get_axis("left", "right")

	if is_attacking:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
		return

	var mult := 1.0 if is_on_floor() else AIR_MULT
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * RUN_SPEED, ACCELERATION * mult * delta)
		facing_right = direction > 0
		sprite.flip_h = not facing_right
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * mult * delta)

# ── Jump ──

func _handle_jump(delta: float) -> void:
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta

	if Input.is_action_just_pressed("jump"):
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

# ── Combat ──

func _handle_attack(delta: float) -> void:
	# Combo-Reset Timer
	if combo_reset_timer > 0.0:
		combo_reset_timer -= delta
		if combo_reset_timer <= 0.0:
			combo_count = 0

	if Input.is_action_just_pressed("left_click"):
		if $ZeitmaschinenUI.visible:
			return
		if not is_attacking:
			_start_attack()
		elif combo_count < MAX_COMBO:
			combo_queued = true

func _start_attack() -> void:
	is_attacking = true
	combo_count += 1
	combo_queued = false
	combo_reset_timer = 0.0
	sprite.play("hit")

func _on_animation_finished() -> void:
	if sprite.animation != "hit":
		return
	if combo_queued and combo_count < MAX_COMBO:
		# Nächster Combo-Schlag
		_start_attack()
	else:
		# Combo vorbei
		is_attacking = false
		combo_queued = false
		combo_reset_timer = COMBO_RESET_TIME


# ── Animation ──

func _update_animation() -> void:
	if is_attacking:
		return
	if not is_on_floor():
		sprite.play("jump")
	elif velocity.x != 0:
		sprite.play("run")
	else:
		sprite.play("idle")

# ── Damage / Save ──

func take_damage(damage: float) -> void:
	save.hp -= damage
	SaveManager.save_all(0)

func _on_timer_timeout() -> void:
	SaveManager.save_all(0)

func _handle_escape() -> void:
	if Input.is_action_just_pressed("escape"):
		if get_tree().paused:
			ESCAPEMENUINSTANCE.hide_menu()
		else:
			ESCAPEMENUINSTANCE.show_menu()
