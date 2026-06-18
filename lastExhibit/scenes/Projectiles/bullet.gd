extends Area2D

var direction: Vector2 = Vector2.LEFT
var speed: float = 600.0
var damage: float = 10.0
var start_position: Vector2

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	start_position = global_position
	
	if direction == Vector2.RIGHT:
		scale.x = -1.0
	else:
		scale.x = 1.0

func _process(delta: float) -> void:
	global_position += direction * speed * delta
	
	if global_position.distance_to(start_position) >= 500.0:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		var player_hurtbox = body.get_node_or_null("Hurtbox")
		if player_hurtbox and player_hurtbox.has_signal("hurt"):
			player_hurtbox.hurt.emit(damage, Vector2.ZERO)
		elif body.has_method("take_damage"):
			body.take_damage(damage)
			
		queue_free()
