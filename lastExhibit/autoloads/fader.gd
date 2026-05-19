extends CanvasLayer

@onready var rect = $ColorRect

func _ready() -> void:
	rect.color = Color(0, 0, 0, 0)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	get_tree().tree_changed.connect(_on_tree_changed)

func _on_tree_changed() -> void:
	# If we're currently faded out (black), fade back in once the new scene is ready
	if rect.color.a > 0.0:
		await get_tree().process_frame
		fade_in(1.0)

func fade_out(duration: float = 0.5) -> void:
	var tween = create_tween()
	tween.tween_property(rect, "color", Color(0, 0, 0, 1), duration)
	await tween.finished

func fade_in(duration: float = 0.5) -> void:
	var tween = create_tween()
	tween.tween_property(rect, "color", Color(0, 0, 0, 0), duration)
	await tween.finished
