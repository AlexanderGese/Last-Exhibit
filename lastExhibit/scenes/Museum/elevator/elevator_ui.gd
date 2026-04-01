extends Control
@onready var player = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		visible = false
	if Input.is_action_just_pressed("interact"):
		visible = true


func _on_floor_2_pressed() -> void:
	player.global_position = Vector2(-98.0 , -2227.0)

func _on_floor_1_pressed() -> void:
	player.global_position = Vector2(-115.0 , -1591.0)

func _on_floor_0_pressed() -> void:
	player.global_position = Vector2(-9.0,-923.0)

func _on_basement_pressed() -> void:
	player.global_position = Vector2(47.0, -246.0)
