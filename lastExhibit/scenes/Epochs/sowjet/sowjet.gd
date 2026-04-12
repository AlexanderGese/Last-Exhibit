extends Node

var player_collided: bool = false


func _ready() -> void:
	add_to_group("sowjet")

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_collided = true


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_collided = false

func _process(_delta: float) -> void:
	if player_collided and Input.is_action_just_pressed("interact"):
		var ui = get_tree().get_first_node_in_group("player").get_node("ZeitmaschinenUI")
		if ui.visible:
			ui.do_hide()
		else:
			ui.do_show()
