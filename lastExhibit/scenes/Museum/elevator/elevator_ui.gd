extends Control
@onready var player = get_parent()

func _ready() -> void:
	hide()

func _on_floor_button_pressed(floor: int) -> void:
	var player = get_parent()
	match floor:
		0: player.global_position = Vector2(100, 500)  # EG
		1: player.global_position = Vector2(100, 200)  # U1
		2: player.global_position = Vector2(100, -100) # U2
	hide()

func _on_floor_2_pressed() -> void:
	player.global_position = Vector2(-98.0 , -2227.0)
	hide()

func _on_floor_1_pressed() -> void:
	player.global_position = Vector2(-115.0 , -1591.0)
	hide()
	
func _on_floor_0_pressed() -> void:
	player.global_position = Vector2(-9.0,-923.0)
	hide()

func _on_basement_pressed() -> void:
	player.global_position = Vector2(47.0, -246.0)
	hide()
