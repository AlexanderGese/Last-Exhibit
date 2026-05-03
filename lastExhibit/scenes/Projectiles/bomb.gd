extends Area2D

var speed: float = 200.0
var damage: float = 25.0

func _process(delta: float) -> void:
	position.y += speed * delta
	if position.y > 2000:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.take_damage(damage)
		queue_free()
