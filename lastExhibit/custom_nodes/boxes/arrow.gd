extends Hitbox

const SPEED = 500.0
const LIFETIME = 3.0

var direction: Vector2 = Vector2.RIGHT
var alive_time: float = 0.0

func _ready() -> void:
	print("Arrow _ready, position: ", global_position)
	area_entered.connect(_on_hit_something)
	body_entered.connect(_on_hit_wall)

func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta
	alive_time += delta
	if alive_time > LIFETIME:
		print("Arrow lifetime exceeded")
		queue_free()

func _on_hit_something(area: Area2D) -> void:
	print("Arrow hit area: ", area, " (parent: ", area.get_parent(), ")")
	if area is Hurtbox:
		queue_free()

func _on_hit_wall(body: Node) -> void:
	print("Arrow hit body: ", body)
	queue_free()
