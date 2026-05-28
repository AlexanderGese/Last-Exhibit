extends Area2D

@export var speed    : float = 600.0
@export var damage   : float = 5.0
@export var lifetime : float = 2.0
var direction        : Vector2 = Vector2.RIGHT

func setup(start: Vector2, dir: Vector2) -> void:
	global_position = start
	var winkel      = randf_range(-4.0, 4.0)
	direction       = dir.rotated(deg_to_rad(winkel))

func _ready() -> void:
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.take_damage(damage)
	queue_free()
