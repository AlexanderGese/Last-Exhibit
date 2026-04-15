extends Node

var player_collided: bool = true


func _ready() -> void:
	add_to_group("sowjet")

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_collided = true


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_collided = false

func _process(_delta: float) -> void:
	if player_collided and Input.is_action_just_pressed("up")
	
	
