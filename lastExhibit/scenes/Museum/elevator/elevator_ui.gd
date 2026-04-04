extends Control

@onready var player = get_parent()
@onready var basementbutton = $GridContainer/Basement/AnimatedSprite2D1
@onready var floor0button = $GridContainer/Floor0/AnimatedSprite2D2
@onready var floor1button = $GridContainer/Floor1/AnimatedSprite2D3
@onready var floor2button = $GridContainer/Floor2/AnimatedSprite2D4

var current_elevator: Node2D = null

const FLOOR_POSITIONS = {
	"basement": Vector2(50.0, -242.0 -31),
	"floor0":   Vector2(-9.0, -920.0 +-31),
	"floor1":   Vector2(-115.0, -1582.0 -31),
	"floor2":   Vector2(-115.0, -2255.0 -31),
}

func _ready() -> void:
	hide()

func _travel_to(floor_name: String, button: AnimatedSprite2D) -> void:
	player.set_physics_process(false)
	button.play(floor_name)
	await get_tree().create_timer(0.75).timeout
	hide()

	if current_elevator:
		current_elevator.visible = true
		current_elevator.show_inside(1.5)
		await get_tree().create_timer(0.2).timeout
		current_elevator.play_closing_animation()
		await get_tree().create_timer(1.0).timeout
		current_elevator.visible = false

	await Fader.fade_out(1.0)
	player.visible = false
	player.get_node("Camera2D").position_smoothing_enabled = false
	player.global_position = FLOOR_POSITIONS[floor_name]
	await get_tree().create_timer(0.05).timeout
	player.get_node("Camera2D").position_smoothing_enabled = true
	player.visible = true
	
	var elevators = get_tree().get_nodes_in_group("elevator")
	for elevator in elevators:
		if elevator.floor_name == floor_name:
			elevator.visible = true
			elevator.play_opening_animation()
			break

	await Fader.fade_in(2.0)
	hide()
	player.set_physics_process(true)

func _on_basement_pressed() -> void:
	await _travel_to("basement", basementbutton)

func _on_floor_0_pressed() -> void:
	await _travel_to("floor0", floor0button)

func _on_floor_1_pressed() -> void:
	await _travel_to("floor1", floor1button)

func _on_floor_2_pressed() -> void:
	await _travel_to("floor2", floor2button)
