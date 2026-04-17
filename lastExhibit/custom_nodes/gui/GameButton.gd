class_name GameButton
extends NinePatchRect

@export var text: String = "Button":
	set(value):
		text = value
		if is_node_ready():
			$HBoxContainer/ButtonLabel.text = value

@export var icon_texture: Texture2D = null:
	set(value):
		icon_texture = value
		if is_node_ready():
			$HBoxContainer/Icon.texture = value
			$HBoxContainer/Icon.visible = value != null

signal pressed

func _ready() -> void:
	$HBoxContainer/ButtonLabel.text = text
	$HBoxContainer/Icon.visible = icon_texture != null

func _dgui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		pressed.emit()
