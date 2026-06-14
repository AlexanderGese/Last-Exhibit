extends Hitbox

@export var speed: float = 600.0
@export var lifetime: float = 2.0

var direction: Vector2 = Vector2.RIGHT
var alive_time: float = 0.0


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)


func setup(start: Vector2, dir: Vector2) -> void:
	global_position = start
	var winkel = randf_range(-4.0, 4.0)
	direction = dir.rotated(deg_to_rad(winkel))


func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	alive_time += delta
	if alive_time > lifetime:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		queue_free()


func _on_body_entered(body: Node) -> void:
	queue_free()
