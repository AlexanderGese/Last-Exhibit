extends Area2D

@export var floor_name: String = ""
var player_collided: bool = false

func _ready() -> void:
	add_to_group("elevator")


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_collided = true


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_collided = false

func _move(hight: float ) -> void:
	move_local_y(-hight)

func _process(_delta: float) -> void:
	if player_collided and Input.is_action_just_pressed("down"):
		for n in 97:
			move_local_y(2)
	if player_collided and Input.is_action_just_pressed("up"):
		for n in 97:
			move_local_y(-2)
