extends Area2D

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		var ui = body.get_node("ElevatorUI")
		ui.show()

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		var ui = body.get_node("ElevatorUI")
		ui.hide()
