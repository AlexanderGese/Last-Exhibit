extends CharacterBody2D

@export var dialogue: DialogueResource
@export var dialogue_alien: DialogueResource
@export var dialogue_beleidigt: DialogueResource

@onready var angesprochen : bool = false
@onready var alien : bool = false
@onready var beleidigt : bool = false
@onready var balloon_scene = preload("res://dialogues/balloon.tscn")
@onready var balloon_scene_alien = preload("res://dialogues/balloon_alien.tscn")
@onready var balloon_scene_beleidigt = preload("res://dialogues/balloon_beleidigt.tscn")
@onready var collision1 = $CollisionShape2D
@onready var collision2 = $Area2D/CollisionShape2D

var current_balloon = null

signal dialogue_started 
signal dialogue_ended

const leben : int = 5
const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _ready(): 
	pass

func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func set_alien():
	alien = true

func set_beleidigt():
	beleidigt = true

func _on_area_2d_body_entered(body: Node) -> void:
	if body.is_in_group("player"): 
		zeige_balloon()


func zeige_balloon(): 
	emit_signal("dialogue_started")
	set_collision_mask_value(1, false)
	if alien == true:
		current_balloon = balloon_scene_alien.instantiate()
	elif beleidigt == true:
		current_balloon = balloon_scene_beleidigt.instantiate()
	else: current_balloon = balloon_scene.instantiate()
	get_tree().current_scene.add_child(current_balloon)
	if alien == true:
		DialogueManager.show_dialogue_balloon_scene(current_balloon, dialogue_alien, "start",[])
	elif beleidigt == true:
		DialogueManager.show_dialogue_balloon_scene(current_balloon, dialogue_beleidigt, "start", [])
	else: 
		DialogueManager.show_dialogue_balloon_scene(current_balloon, dialogue, "start", [self])

func signal_ended():
	emit_signal("dialogue_ended")

func _on_area_2d_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		signal_ended()
		abort_dialogue()
		
func abort_dialogue():
	if current_balloon:
		signal_ended()
		set_collision_mask_value(1, true)
		current_balloon.queue_free()
		current_balloon = null


func _on_player_pause() -> void:
	abort_dialogue()
