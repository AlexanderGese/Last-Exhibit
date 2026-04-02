extends Control
@onready var player = get_parent()
@onready var basementbutton = $GridContainer/Basement/AnimatedSprite2D1
@onready var floor0button = $GridContainer/Floor0/AnimatedSprite2D2
@onready var floor1button = $GridContainer/Floor1/AnimatedSprite2D3
@onready var floor2button = $GridContainer/Floor2/AnimatedSprite2D4


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
	floor2button.play("floor2")
	await get_tree().create_timer(0.75).timeout
	player.global_position = Vector2(-98.0 , -2227.0)
	hide()

func _on_floor_1_pressed() -> void:
	floor1button.play("floor1")
	await get_tree().create_timer(0.75).timeout
	player.global_position = Vector2(-115.0 , -1591.0)
	hide()

func _on_floor_0_pressed() -> void:
	floor0button.play("floor0")
	await get_tree().create_timer(0.75).timeout
	player.global_position = Vector2(-9.0,-923.0)
	hide()

func _on_basement_pressed() -> void:
	basementbutton.play("basement")
	await get_tree().create_timer(0.75).timeout
	player.global_position = Vector2(47.0, -246.0)
	hide()
