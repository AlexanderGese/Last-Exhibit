class_name Ladder
extends Area2D
# Passive ladder marker. All climbing movement lives in the Player — the ladder
# only reports when the player enters/leaves and exposes its climb column (the
# world-space X the player snaps to while climbing). No _process, no velocity
# writing, no counting.

@onready var _shape: CollisionShape2D = $CollisionShape2D

# World X of the ladder's climb column (centre of the collision shape).
func climb_x() -> float:
	return global_position.x + _shape.position.x

# Wired from Ladder.tscn's body_entered / body_exited signal connections.
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") and body.has_method("enter_ladder"):
		body.enter_ladder(self)

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player") and body.has_method("exit_ladder"):
		body.exit_ladder(self)
