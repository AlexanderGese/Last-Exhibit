extends Area2D

var in_main: bool = false
#@onready var sprite_2d: AnimatedSprite2D = $Sprite2D


func _process(delta: float) -> void:
	if in_main and Input.is_action_just_pressed("interact"):
		Events.in_level = false
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			var player = players[0]
			if not player.getDurchgespielt():
				player.setDurchgespielt()
				get_tree().change_scene_to_file("res://scenes/GUI/Credits.tscn")
			else:
				get_tree().change_scene_to_file("res://scenes/Museum/Museum.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/Museum/Museum.tscn")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_main = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_main = false
