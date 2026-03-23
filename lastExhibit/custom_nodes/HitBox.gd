class_name HitBox
extends Area2D

@export var damage := 10
@export var knockback := Vector2.ZERO

func _init() -> void:
	collision_layer = 2
	collision_mask = 0
