class_name Ladder
extends Area2D


func climb_x(from_x: float) -> float:
	var best := global_position.x
	var best_d := INF
	for c in get_children():
		if c is CollisionShape2D:
			var x: float = global_position.x + c.position.x
			var d: float = absf(x - from_x)
			if d < best_d:
				best_d = d
				best = x
	return best


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") and body.has_method("enter_ladder"):
		body.enter_ladder(self)


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player") and body.has_method("exit_ladder"):
		body.exit_ladder(self)
