
extends CharacterBody2D

@export var walk_speed  : float = 180.0
@export var run_speed   : float = 350.0
@export var gravity     : float = 980.0
@export var min_x       : float = 4160.0
@export var max_x       : float = 4830.0
@export var kampf_dist  : float = 64.0
@export var run_distanz : float = 128.0

var player : CharacterBody2D
var facing_right : bool = true

func _ready() -> void:
	await get_tree().process_frame
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func setup(x: float, y: float) -> void:
	global_position = Vector2(x, y)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if player == null:
		return

	_move_towards_player()
	_update_facing()
	move_and_slide()

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
