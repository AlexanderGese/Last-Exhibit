extends CharacterBody2D

@export var speed: float = 180.0
@export var gravity: float = 980.0
@export var is_dead: bool = false
@export var is_attacking: bool = false
@export var attack_cooldown: float = 0.2
var can_attack: bool = true
@onready var attack_zone = get_node_or_null("AttackZone")
@onready var detection_zone = get_node_or_null("DetectionZone")
var player_detected: bool = false
@onready var animated_sprite = $AnimatedSprite2D
@onready var ray_cast_floor = get_node_or_null("RayCastFloor")
@export var max_health: int = 100
var current_health: int = max_health
@onready var enemy_hurtbox = get_node_or_null("Hurtbox")



var player: Node2D = null

func _ready():
	animated_sprite.animation_finished.connect(_on_animation_finished)
	
	if enemy_hurtbox:
		enemy_hurtbox.hurt.connect(_on_enemy_hurt)
	
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_dead:
		if is_on_floor():
			velocity.x = 0
		else:
			velocity.x = move_toward(velocity.x, 0, speed * delta)
			velocity.y += gravity * delta
		
		move_and_slide()
		return

	if player == null:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			player = players[0]

	if is_attacking:
		velocity.x = move_toward(velocity.x, 0, speed * 2 * delta)
		move_and_slide()
		return
	elif player and is_player_in_attack_zone():
		velocity.x = move_toward(velocity.x, 0, speed * 2 * delta)
		if can_attack:
			punch()
		else:
			animated_sprite.play("idle")
	elif player and player_detected:
		move_towards_player()
	else:
		velocity.x = 0
		animated_sprite.play("idle")
		
	move_and_slide()

func move_towards_player():
	var x_distance = player.global_position.x - global_position.x
	var direction = sign(x_distance)

	if abs(x_distance) < 10.0:
		velocity.x = 0
		animated_sprite.play("idle")
		return

	var has_floor_ahead = true
	if direction != 0 and ray_cast_floor:
		ray_cast_floor.position.x = direction * 15.0
		if not ray_cast_floor.is_colliding():
			has_floor_ahead = false

	if direction != 0 and has_floor_ahead:
		velocity.x = direction * speed
		animated_sprite.play("run")
		animated_sprite.flip_h = (direction < 0)
		if attack_zone:
			attack_zone.scale.x = direction
	else:
		velocity.x = 0
		animated_sprite.play("idle")

func is_player_in_attack_zone() -> bool:
	if attack_zone == null: 
		return false
	var bodies = attack_zone.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player") and body == player:
			return true
	return false

func punch():
	is_attacking = true
	can_attack = false
	velocity.x = 0
	animated_sprite.play("attack")

func _on_animation_finished():
	if animated_sprite.animation == "attack":
		is_attacking = false
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true
	
	elif animated_sprite.animation == "die" or animated_sprite.animation == "death":
		queue_free()

func _on_detection_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_detected = true

func _on_detection_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_detected = false


func _on_enemy_hurt(damage: int, _knockback):
	if is_dead:
		return
		
	current_health -= damage
	print("Gegner wurde getroffen! Verbleibendes Leben: ", current_health)
	
	if player:
		var push_direction = sign(global_position.x - player.global_position.x)
		velocity = Vector2(push_direction * 200.0, -150.0)
	
	if current_health <= 0:
		die()

func die():
	is_dead = true
	is_attacking = false
	
	if enemy_hurtbox:
		enemy_hurtbox.set_deferred("monitoring", false)
		enemy_hurtbox.set_deferred("monitorable", false)
		
	if attack_zone:
		attack_zone.set_deferred("monitoring", false)
	
	animated_sprite.play("die")
	
	await get_tree().create_timer(1.5).timeout
	queue_free()
