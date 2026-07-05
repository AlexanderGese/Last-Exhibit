extends Node2D

@export var dialogue : DialogueResource
@onready var balloon_scene = preload("res://dialogues/dummys/dummy1.tscn")
var current_balloon = null

var angesprochen : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_angesprochen():
	angesprochen = true

func signal_started(): 
	Events.dialogue_started.emit()
	
func signal_ended():
	Events.dialogue_ended.emit()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") && !angesprochen : 
		zeige_balloon()
		

func zeige_balloon(): 
	signal_started()
	current_balloon = balloon_scene.instantiate()
	get_tree().current_scene.add_child(current_balloon)
	current_balloon.start(dialogue, "start", [self])


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		abort_dialogue()

func abort_dialogue():
	if current_balloon:
		signal_ended()
		current_balloon.queue_free()
		current_balloon = null


func _on_player_pause() -> void:
	abort_dialogue()
