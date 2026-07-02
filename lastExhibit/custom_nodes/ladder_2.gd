extends Area2D

var is_in_area: bool = false
var player_ref: CharacterBody2D = null
@export var hoehe: float = 200.0
@export var ladder_speed: float = 200.0

func _ready() -> void:
	_update_size()

func _update_size() -> void:
	if $CollisionShape2D.shape is RectangleShape2D:
		$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
		$CollisionShape2D.shape.size.y = hoehe

func _process(_delta: float) -> void:
	if not is_in_area or not player_ref:
		return
	#if not player_ref.on_ladder:
	#	return

	if Input.is_action_pressed("up"):
		print("hoch")
		player_ref.velocity.y = -ladder_speed
		player_ref.play_animation("climb")
	elif Input.is_action_pressed("down"):
		print("runter")
		player_ref.velocity.y = ladder_speed
		player_ref.play_animation("climb")
	else:
		player_ref.velocity.y = 0.0
		player_ref.stop_animation()

	if Input.is_action_just_pressed("jump") or \
	   Input.is_action_just_pressed("left") or \
	   Input.is_action_just_pressed("right"):
		player_ref.set_ladder(false)

func _on_body_entered(body: Node) -> void:
	print("drin")
	if body.is_in_group("player"):
		is_in_area = true
		player_ref = body
		if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down"):
			player_ref.set_ladder(true)

func _on_body_exited(body: Node) -> void:
	print("draußen")
	if body.is_in_group("player"):
		is_in_area = false
		player_ref = null
		if player_ref:
			player_ref.set_ladder(false)
