class_name Ladder
extends Area2D

@onready var _shape: CollisionShape2D = $CollisionShape2D

func climb_x() -> float:
	return global_position.x + _shape.position.x

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") and body.has_method("enter_ladder"):
		body.enter_ladder(self)

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player") and body.has_method("exit_ladder"):
		body.exit_ladder(self)
