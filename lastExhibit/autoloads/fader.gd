extends CanvasLayer

@onready var rect = $ColorRect

func _ready() -> void:
	rect.color = Color(0, 0, 0, 0)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func fade_out(duration: float = 0.5) -> void:
	var tween = create_tween()
	tween.tween_property(rect, "color", Color(0, 0, 0, 1), duration)
	await tween.finished

func fade_in(duration: float = 0.5) -> void:
	var tween = create_tween()
	tween.tween_property(rect, "color", Color(0, 0, 0, 0), duration)
	await tween.finished
