class_name Hitbox
extends Area2D

@export var damage: int = 20
@export var knockback_force: float = 200.0

func get_knockback_direction(target_position: Vector2) -> Vector2:
	var dir = (target_position - global_position).normalized()
	return dir * knockback_force
