extends TextureRect

func _ready() -> void:
	resized.connect(_update_size)
	_update_size()

func _update_size() -> void:
	material.set_shader_parameter("size", size)
