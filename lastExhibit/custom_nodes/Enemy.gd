extends CharacterBody2D

# ── Stats ──
@export var max_hp: float = 50.0
@export var move_speed: float = 80.0
@export var chase_speed: float = 150.0
@export var melee_damage: float = 10.0
@export var ranged_damage: float = 5.0
@export var attack_range: float = 48.0
@export var ranged_range: float = 200.0
@export var attack_cooldown: float = 1.5
@export var can_melee: bool = true
@export var can_ranged: bool = false

# ── Node References ──
@export_group("Nodes")
@export var sprite: AnimatedSprite2D
@export var collision: CollisionShape2D
@export var hitbox: Area2D
@export var hitbox_shape: CollisionShape2D
@export var hurtbox: Area2D
@export var hurtbox_shape: CollisionShape2D
@export var detection_zone: Area2D
@export var detection_shape: CollisionShape2D
@export var patrol_left: Marker2D
@export var patrol_right: Marker2D
@export var projectile_spawn: Marker2D

# ── Optional ──
@export_group("Combat")
@export var projectile_scene: PackedScene

# ── State ──
var hp: float
var player: CharacterBody2D = null
var is_dead: bool = false
var attack_timer: float = 0.0

const GRAVITY = 2000.0


func _ready() -> void:
	hp = max_hp
	add_to_group("enemy")
	
	if hurtbox and hurtbox.has_signal("hit"):
		hurtbox.hit.connect(_on_hit)
	if detection_zone:
		detection_zone.body_entered.connect(_on_player_detected)
		detection_zone.body_exited.connect(_on_player_lost)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	attack_timer -= delta
	move_and_slide()


# ── State Hooks (für LimboHSM) ──

func patrol_tick(delta: float) -> void:
	pass


func chase_tick(delta: float) -> void:
	pass


func do_melee() -> void:
	pass


func do_ranged() -> void:
	pass


func stop() -> void:
	velocity.x = 0
	if sprite:
		sprite.play("idle")


# ── Damage / Death ──

func _on_hit(damage: float, knockback: Vector2) -> void:
	if is_dead:
		return
	hp -= damage
	velocity += knockback
	if hp <= 0:
		die()


func die() -> void:
	is_dead = true
	if collision:
		collision.set_deferred("disabled", true)
	if sprite:
		sprite.play("death")


# ── Detection ──

func _on_player_detected(body: Node) -> void:
	if body.is_in_group("player"):
		player = body


func _on_player_lost(body: Node) -> void:
	if body.is_in_group("player"):
		player = null


func get_player_distance() -> float:
	if player == null:
		return INF
	return global_position.distance_to(player.global_position)
