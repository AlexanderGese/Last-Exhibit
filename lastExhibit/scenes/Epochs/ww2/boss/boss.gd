# P51Boss.gd
extends Node2D

@export var max_move_speed: float = 200.0
@export var bullet_speed: float = 400.0
@export var attack_cooldown: float = 2.0

var phase: int = 1
var attack_timer: float = 0.0
var player: CharacterBody2D = null
var is_dead: bool = false
var direction: int = 1
var move_speed: float = 200.0

@onready var sprite = $AnimatedSprite2D
@onready var health = $Health
@onready var hitbox = $Hitbox
@onready var projectile_spawn = $ProjectileSpawn
@onready var bomb_spawn = $BombSpawn
@onready var flight_zone = $FlightZone/CollisionShape2D

const BULLET_SCENE = preload("res://scenes/Projectiles/Bullet.tscn")
const BOMB_SCENE = preload("res://scenes/Projectiles/Bomb.tscn")

func _ready() -> void:
	health.damaged.connect(_on_damaged)
	health.death.connect(_on_death)
	player = get_tree().get_first_node_in_group("player")
	sprite.play("fly")

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	attack_timer -= delta
	_update_phase()
	_clamp_to_flight_zone()

# ── Phase ─────────────────────────────────────────────
func _update_phase() -> void:
	var current_hp = health.get_current()
	var max_hp = health.max_health
	if current_hp <= max_hp * 0.66 and phase < 2:
		phase = 2
		move_speed = 300.0
		attack_cooldown = 1.5
	elif current_hp <= max_hp * 0.33 and phase < 3:
		phase = 3
		move_speed = 400.0
		attack_cooldown = 1.0

# ── Movement ──────────────────────────────────────────
func patrol_flight() -> void:
	position.x += move_speed * direction * get_process_delta_time()
	sprite.flip_h = direction > 0
	var shape = flight_zone.shape as RectangleShape2D
	var left = $FlightZone.global_position.x - shape.size.x / 2
	var right = $FlightZone.global_position.x + shape.size.x / 2
	if global_position.x >= right:
		direction = -1
	elif global_position.x <= left:
		direction = 1

func chase_player() -> void:
	if player == null:
		return
	var dir = sign(player.global_position.x - global_position.x)
	position.x += move_speed * dir * get_process_delta_time()
	var target_y = player.global_position.y - 150
	position.y = lerp(position.y, target_y, 0.02)
	sprite.flip_h = dir > 0

func _clamp_to_flight_zone() -> void:
	var shape = flight_zone.shape as RectangleShape2D
	var center = $FlightZone.global_position
	var half = shape.size / 2
	global_position.x = clamp(global_position.x, center.x - half.x, center.x + half.x)
	global_position.y = clamp(global_position.y, center.y - half.y, center.y + half.y)

# ── Attacks ───────────────────────────────────────────
func shoot_bullets() -> void:
	if attack_timer > 0:
		return
	attack_timer = attack_cooldown
	var bullet = BULLET_SCENE.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = projectile_spawn.global_position
	bullet.direction = Vector2(direction, 0)
	bullet.speed = bullet_speed

func drop_bomb() -> void:
	if attack_timer > 0 or phase < 2:
		return
	attack_timer = attack_cooldown
	var bomb = BOMB_SCENE.instantiate()
	get_parent().add_child(bomb)
	bomb.global_position = bomb_spawn.global_position

# ── Damage ────────────────────────────────────────────
func _on_damaged(amount: float, knockback: Vector2) -> void:
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE

func _on_death() -> void:
	is_dead = true
	$Hitbox/CollisionShape2D.disabled = true
	sprite.play("crash")
	await sprite.animation_finished
	queue_free()

# ── Blackboard Bridge ─────────────────────────────────
func get_hp() -> float:
	return health.get_current()

func get_phase() -> int:
	return phase

func get_attack_timer() -> float:
	return attack_timer

func is_player_detected() -> bool:
	return player != null
