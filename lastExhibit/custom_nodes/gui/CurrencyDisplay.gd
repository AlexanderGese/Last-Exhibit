class_name CurrencyDisplay
extends HBoxContainer

@export var icon_texture: Texture2D = null:
	set(value):
		icon_texture = value
		if is_node_ready():
			$Icon.texture = value

@export var value: int = 0:
	set(v):
		value = v
		if is_node_ready():
			$ValueLabel.text = str(v)

func _ready() -> void:
	$Icon.texture = icon_texture
	$ValueLabel.text = str(value)
