extends Area2D

var is_in_area: bool = false
var player_ref: CharacterBody2D = null
var size

func _process(delta: float) -> void:
	if is_in_area and player_ref:
		if Input.is_action_pressed("up"):
			player_ref.velocity.y = -200
		elif Input.is_action_pressed("down"):
			player_ref.velocity.y = 200
		else:
			player_ref.velocity.y = 0
		if Input.is_action_just_pressed("right"):
			player_ref.velocity.x = 200
		elif Input.is_action_just_pressed("left"):
			player_ref.velocity.x = -200

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		is_in_area = true
		player_ref = body
		
		body.ladder_count += 1
		if body.has_method("enter_ladder"):
			body.enter_ladder(self)

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		body.ladder_count -= 1
		is_in_area = false
		player_ref = null
