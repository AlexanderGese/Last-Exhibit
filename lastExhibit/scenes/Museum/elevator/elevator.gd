extends Area2D

var player_collided: bool = false
@export var floor_name: String =""
@export var display_texture: Texture2D:
	set(value):
		display_texture = value
		$Sprite2D.texture = value

func _ready() -> void:
	add_to_group("elevator")
	$Sprite2D.visible = false
	$AnimatedSprite2D.visible = false

func play_closing_animation():
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("doors_closing")

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_collided = true
		$ElevatorPrompt.visible = true
		#print ("colldide")
		#print (body.name)

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_collided = false
		$ElevatorPrompt.visible = false
		#print ("exit")
		var ui = get_tree().get_first_node_in_group("player").get_node("ElevatorUI")
		ui.hide()

func _process(_delta: float) -> void:
	if player_collided and Input.is_action_just_pressed("interact"):
		var ui = get_tree().get_first_node_in_group("player").get_node("ElevatorUI")
		ui.current_elevator = self
		ui.show()

func show_inside(duration: float):
	$Sprite2D.visible = true
	await get_tree().create_timer(2).timeout
	$Sprite2D.visible = false

func play_opening_animation() -> void:
	visible = true
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play_backwards("doors_closing")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.visible = false
