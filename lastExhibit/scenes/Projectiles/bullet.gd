extends Area2D

var direction: Vector2 = Vector2.LEFT
var speed: float = 400.0
var damage: float = 15.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	position += direction * speed * delta
	if position.x < -1000 or position.x > 3000:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.take_damage(damage)
		queue_free()
