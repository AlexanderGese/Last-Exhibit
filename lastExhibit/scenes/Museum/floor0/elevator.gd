extends Node2D

var player_collided: bool = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		player_collided = true
		#print ("colldide")
		#print (body.name)
		$ElevatorPrompt.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		player_collided = false
		#print ("exit")
		$ElevatorPrompt.visible = false
