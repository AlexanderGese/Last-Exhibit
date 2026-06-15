
extends CharacterBody2D

@export var walk_speed   : float = 180.0
@export var run_speed    : float = 280.0
@export var gravity      : float = 980.0
@export var min_x        : float = 4160.0
@export var max_x        : float = 4830.0
@export var kampf_dist   : float = 50.0
@export var run_distanz  : float = 100.0
@export var hit_cooldown : float = 3.0
@export var hit_distanz  : float = 70.0

@onready var sprite_root = $SpriteRoot

var hit_timer    : float = 0.0
var is_attacking : bool  = false
var hat_getroffen : bool = false
var player : CharacterBody2D
var facing_right : bool = true

func _ready() -> void:
	await get_tree().process_frame
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	$Hitbox.monitoring = false
	$Hitbox.area_entered.connect(_on_hitbox_area_entered)

func setup(x: float, y: float) -> void:
	global_position = Vector2(x, y)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if player == null:
		return
	hit_timer -= delta
	var dist_x = abs(global_position.x - player.global_position.x)
	if is_attacking:
		velocity.x = 0.0
	elif dist_x <= hit_distanz and hit_timer <= 0.0:
		_hit_start()
	else:
		_move_towards_player()
	_update_facing()
	move_and_slide()

func _hit_start() -> void:
	is_attacking  = true
	hat_getroffen = false
	hit_timer     = hit_cooldown
	velocity.x    = 0.0
	var anim : String
	if randf() < 0.5:
		anim = "attack1"
	else:
		anim = "attack2"
	$AnimatedSprite2D.play(anim)
	await get_tree().create_timer(0.8 ).timeout  # ← anpassen bis es passt
	$Hitbox.set_deferred("monitoring", true)
	await get_tree().create_timer(0.2).timeout
	$Hitbox.set_deferred("monitoring", false)
	$AnimatedSprite2D.play("idle")
	is_attacking = false

func _on_hitbox_area_entered(area: Area2D) -> void:
	if hat_getroffen:
		return
	if area is Hurtbox:
		hat_getroffen = true
		$Hitbox.set_deferred("monitoring", false)  # ← sofort aus nach erstem Treffer
		var knockback = $Hitbox.get_knockback_direction(area.global_position)
		area.hurt.emit($Hitbox.damage, knockback)

func _move_towards_player() -> void:
	var dist = global_position.distance_to(player.global_position)
	var dir  = sign(player.global_position.x - global_position.x)
	if global_position.x <= min_x and dir < 0:
		velocity.x = 0.0
		return
	if global_position.x >= max_x and dir > 0:
		velocity.x = 0.0
		return
	if dist <= kampf_dist:
		velocity.x = move_toward(velocity.x, 0.0, 20.0)
		$AnimatedSprite2D.play("idle")
		return
	if dist > run_distanz:
		velocity.x = dir * run_speed
		$AnimatedSprite2D.play("run")
	else:
		velocity.x = dir * walk_speed
		$AnimatedSprite2D.play("walk")

func _update_facing() -> void:
	if velocity.x > 5.0:
		facing_right = true
	elif velocity.x < -5.0:
		facing_right = false
	else:
		facing_right = player.global_position.x > global_position.x
	$AnimatedSprite2D.flip_h = not facing_right
	$AnimatedSprite2D.position.x = 30.0 if facing_right else -30.0
