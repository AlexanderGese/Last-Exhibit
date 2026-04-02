extends Area2D

var player_collided: bool = false

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_collided = true
		$ElevatorPrompt.visible = true
		#print ("colldide")
		#print (body.name)

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_collided = false
		$ElevatorPrompt.visible = false
		#print ("exit")
		var ui = get_tree().get_first_node_in_group("player").get_node("ElevatorUI")
		ui.hide()

func _process(_delta: float) -> void:
	if player_collided and Input.is_action_just_pressed("interact"):
		var ui = get_tree().get_first_node_in_group("player").get_node("ElevatorUI")
		ui.show()
