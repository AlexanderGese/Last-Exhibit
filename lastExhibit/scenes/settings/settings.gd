extends Control

@onready var settingsmenu: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	settingsmenu.play("roll down")
	await get_tree().create_timer(0.5).timeout
	settingsmenu.play("default")

func rebind_action(action_name: String, keycode: int):
	InputMap.action_erase_events(action_name)

	var ev := InputEventKey.new()
	ev.physical_keycode = keycode
	InputMap.action_add_event(action_name, ev)
