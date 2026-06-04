extends Area2D

@export var damage : float = 40.0

func _ready() -> void:
	pass

func explode() -> void:
	$AnimatedSprite2D.play("explosion")
	await get_tree().create_timer(0.1).timeout
	_deal_damage()
	await $AnimatedSprite2D.animation_finished
	print("queue_free: ", get_instance_id())
	queue_free()

func _deal_damage() -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			body.take_damage(damage)
