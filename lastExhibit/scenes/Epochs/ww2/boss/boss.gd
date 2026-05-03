# P51Boss.gd
extends CharacterBody2D

@export var max_hp: float = 300.0
@export var move_speed: float = 200.0
@export var bullet_speed: float = 400.0
@export var attack_cooldown: float = 2.0

var hp: float
var phase: int = 1
var attack_timer: float = 0.0
var player: CharacterBody2D = null
var is_dead: bool = false
var direction: int = 1

@onready var sprite = $AnimatedSprite2D
@onready var hitbox = $HitBox/CollisionShape2D
@onready var hurtbox = $HurtBox
@onready var projectile_spawn = $ProjectileSpawn
@onready var bomb_spawn = $BombSpawn
@onready var flight_zone = $FlightZone

const BULLET_SCENE = preload("res://scenes/Projectiles/Bullet.tscn")
const BOMB_SCENE = preload("res://scenes/Projectiles/Bomb.tscn")

func _ready() -> void:
	hp = max_hp
	hurtbox.hit.connect(_on_hit)
	player = get_tree().get_first_node_in_group("player")
	sprite.play("fly")

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	attack_timer -= delta
	_update_phase()
	_clamp_to_flight_zone()

func _update_phase() -> void:
	if hp <= max_hp * 0.66 and phase < 2:
		phase = 2
		move_speed = 300.0
		attack_cooldown = 1.5
	elif hp <= max_hp * 0.33 and phase < 3:
		phase = 3
		move_speed = 400.0
		attack_cooldown = 1.0

func patrol_flight() -> void:
	position.x += move_speed * direction * get_process_delta_time()
	sprite.flip_h = direction > 0
	var zone_rect = flight_zone.get_node("CollisionShape2D").shape.get_rect()
	var left = flight_zone.global_position.x + zone_rect.position.x
	var right = flight_zone.global_position.x + zone_rect.end.x
	if global_position.x >= right:
		direction = -1
	elif global_position.x <= left:
		direction = 1

func chase_player() -> void:
	if player == null:
		return
	var dir = sign(player.global_position.x - global_position.x)
	position.x += move_speed * dir * get_process_delta_time()
	# Höhe anpassen
	var target_y = player.global_position.y - 150
	position.y = lerp(position.y, target_y, 0.02)
	sprite.flip_h = dir > 0

func _clamp_to_flight_zone() -> void:
	var zone_rect = flight_zone.get_node("CollisionShape2D").shape.get_rect()
	var left = flight_zone.global_position.x + zone_rect.position.x
	var right = flight_zone.global_position.x + zone_rect.end.x
	var top = flight_zone.global_position.y + zone_rect.position.y
	var bottom = flight_zone.global_position.y + zone_rect.end.y
	global_position.x = clamp(global_position.x, left, right)
	global_position.y = clamp(global_position.y, top, bottom)

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

func _on_hit(damage: float, knockback: Vector2) -> void:
	if is_dead:
		return
	hp -= damage
	if hp <= 0:
		die()

func die() -> void:
	is_dead = true
	hitbox.disabled = true
	sprite.play("crash")
	await sprite.animation_finished
	queue_free()

func get_hp() -> float:
	return hp

func get_phase() -> int:
	return phase

func get_attack_timer() -> float:
	return attack_timer

func is_player_detected() -> bool:
	return player != null
