extends Control


func rebind_action(action_name: String, keycode: int):
	InputMap.action_erase_events(action_name)

	var ev := InputEventKey.new()
	ev.physical_keycode = keycode
	InputMap.action_add_event(action_name, ev)
