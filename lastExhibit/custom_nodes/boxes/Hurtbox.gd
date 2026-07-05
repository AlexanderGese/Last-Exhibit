class_name Hurtbox
extends Area2D

signal hurt(damage: int, knockback: Vector2)

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		var knockback = area.get_knockback_direction(global_position)
		hurt.emit(area.damage, knockback)
		var host = get_parent()
		if host and not host.is_in_group("player"):
			Effects.play("hit")
