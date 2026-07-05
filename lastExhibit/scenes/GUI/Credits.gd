extends CanvasLayer

@export var scroll_speed : float = 200.0
@export var next_scene : String = "res://scenes/Museum/Museum.tscn"

@onready var vbox = $VBoxContainer

func _ready() -> void:
	await get_tree().process_frame
	vbox.position.y = get_viewport().size.y

func _process(delta: float) -> void:
	vbox.position.y -= scroll_speed * delta
	if vbox.position.y + vbox.size.y < 0:
		get_tree().change_scene_to_file(next_scene)
