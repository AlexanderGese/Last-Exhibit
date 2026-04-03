extends Control
@onready var player = get_parent()
@onready var basementbutton = $GridContainer/Basement/AnimatedSprite2D1
@onready var floor0button = $GridContainer/Floor0/AnimatedSprite2D2
@onready var floor1button = $GridContainer/Floor1/AnimatedSprite2D3
@onready var floor2button = $GridContainer/Floor2/AnimatedSprite2D4
var current_elevator: Node2D = null


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
	player.set_physics_process(false)
	floor2button.play("floor2")
	await get_tree().create_timer(0.75).timeout
	hide()
	if current_elevator:
		current_elevator.visible = true
		var door_close = current_elevator.get_node("AnimatedSprite2D")
		current_elevator.show_inside(1.5)
		#print("Versuche Animation zu spielen: ", door_close.name)
		await get_tree().create_timer(0.2).timeout
		current_elevator.play_closing_animation()
		#print("Ist Animation am spielen? ", door_close.is_playing())
		await get_tree().create_timer(1).timeout
		current_elevator.visible = false
	player.global_position = Vector2(-98.0 , -2227.0)
	hide()
	player.set_physics_process(true)

func _on_floor_1_pressed() -> void:
	player.set_physics_process(false)
	floor1button.play("floor1")
	await get_tree().create_timer(0.75).timeout
	hide()
	if current_elevator:
		current_elevator.visible = true
		var door_close = current_elevator.get_node("AnimatedSprite2D")
		current_elevator.show_inside(1.5)
		#print("Versuche Animation zu spielen: ", door_close.name)
		await get_tree().create_timer(0.2).timeout
		current_elevator.play_closing_animation()
		#print("Ist Animation am spielen? ", door_close.is_playing())
		await get_tree().create_timer(1).timeout
		current_elevator.visible = false
	player.global_position = Vector2(-115.0 , -1591.0)
	hide()
	player.set_physics_process(true)

func _on_floor_0_pressed() -> void:
	player.set_physics_process(false)
	floor0button.play("floor0")
	await get_tree().create_timer(0.75).timeout
	hide()
	if current_elevator:
		current_elevator.visible = true
		var door_close = current_elevator.get_node("AnimatedSprite2D")
		current_elevator.show_inside(1.5)
		#print("Versuche Animation zu spielen: ", door_close.name)
		await get_tree().create_timer(0.2).timeout
		current_elevator.play_closing_animation()
		#print("Ist Animation am spielen? ", door_close.is_playing())
		await get_tree().create_timer(1).timeout
		current_elevator.visible = false
	player.global_position = Vector2(-9.0,-923.0)
	hide()
	player.set_physics_process(true)

func _on_basement_pressed() -> void:
	player.set_physics_process(false)
	basementbutton.play("basement")
	await get_tree().create_timer(0.75).timeout
	hide()
	if current_elevator:
		current_elevator.visible = true
		var door_close = current_elevator.get_node("AnimatedSprite2D")
		current_elevator.show_inside(1.5)
		#print("Versuche Animation zu spielen: ", door_close.name)
		await get_tree().create_timer(0.2).timeout
		current_elevator.play_closing_animation()
		#print("Ist Animation am spielen? ", door_close.is_playing())
		await get_tree().create_timer(1).timeout
		current_elevator.visible = false
	player.global_position = Vector2(47.0, -246.0)
	hide()
	player.set_physics_process(true)
