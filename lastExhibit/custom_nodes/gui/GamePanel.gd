class_name GamePanel
extends NinePatchRect

@export var padding: int = 12

@onready var content = $MarginContainer/Content

func _ready() -> void:
	var margin = $MarginContainer
	margin.add_theme_constant_override("margin_left", padding)
	margin.add_theme_constant_override("margin_right", padding)
	margin.add_theme_constant_override("margin_top", padding)
	margin.add_theme_constant_override("margin_bottom", padding)
