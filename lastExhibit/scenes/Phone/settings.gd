extends Control

const REBINDABLE_ACTIONS = [
	"left",
	"right",
	"jump",
	"interact",
	"phone",
	"escape",
	"left_click",
	"right_click",
	"up",
	"down",
]

const DEFAULTS = {
	"left": {"type": "key", "value": KEY_A},
	"right": {"type": "key", "value": KEY_D},
	"jump": {"type": "key", "value": KEY_SPACE},
	"interact": {"type": "key", "value": KEY_E},
	"phone": {"type": "key", "value": KEY_F},
	"escape": {"type": "key", "value": KEY_ESCAPE},
	"up": {"type": "key", "value": KEY_W},
	"down": {"type": "key", "value": KEY_S},
	"left_click": {"type": "mouse", "value": MOUSE_BUTTON_LEFT},
	"right_click": {"type": "mouse", "value": MOUSE_BUTTON_RIGHT},
}

@onready var keybind_list: VBoxContainer = $ScrollContainer/VBoxContainer/KeybindsSection/KeybindList
@onready var reset_button: Button = $ScrollContainer/VBoxContainer/ResetSection/Button

var listening_for_action: String = ""
var listening_button: Button = null
var _volume_sliders := {}


func _ready() -> void:
	reset_button.pressed.connect(_on_reset_pressed)
	_build_audio_controls()
	_build_keybind_list()


func _build_audio_controls() -> void:
	var vbox: VBoxContainer = $ScrollContainer/VBoxContainer
	var section := VBoxContainer.new()
	section.add_theme_constant_override("separation", 6)

	var header := Label.new()
	header.text = "Audio"
	section.add_child(header)

	for entry in [["Master", "Master"], ["Music", "Music"], ["SFX", "VFX"]]:
		var row := HBoxContainer.new()
		row.custom_minimum_size.y = 40

		var label := Label.new()
		label.text = entry[0]
		label.custom_minimum_size.x = 150
		row.add_child(label)

		var slider := HSlider.new()
		slider.min_value = 0.0
		slider.max_value = 1.0
		slider.step = 0.01
		slider.custom_minimum_size.x = 200
		slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		slider.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		slider.value = AudioManager.get_volume(entry[1])
		slider.value_changed.connect(_on_volume_changed.bind(entry[1]))
		row.add_child(slider)
		_volume_sliders[entry[1]] = slider

		section.add_child(row)

	var reset_audio_btn := Button.new()
	reset_audio_btn.text = "Reset Audio to Default"
	reset_audio_btn.pressed.connect(_on_reset_audio_pressed)
	section.add_child(reset_audio_btn)

	vbox.add_child(section)
	vbox.move_child(section, 0)


func _on_volume_changed(value: float, bus: String) -> void:
	AudioManager.set_volume(bus, value)


func _on_reset_audio_pressed() -> void:
	AudioManager.reset_audio()
	for bus in _volume_sliders.keys():
		_volume_sliders[bus].set_value_no_signal(AudioManager.get_volume(bus))


func _build_keybind_list() -> void:
	for child in keybind_list.get_children():
		child.queue_free()
	
	for action in REBINDABLE_ACTIONS:
		var row = HBoxContainer.new()
		row.custom_minimum_size.y = 40
		
		var label = Label.new()
		label.text = action.capitalize()
		label.custom_minimum_size.x = 150
		row.add_child(label)
		
		var button = Button.new()
		button.text = _get_action_display(action)
		button.custom_minimum_size.x = 150
		button.pressed.connect(_start_listening.bind(action, button))
		row.add_child(button)
		
		var reset_btn = Button.new()
		reset_btn.text = "↺"
		reset_btn.pressed.connect(_reset_keybind.bind(action, button))
		row.add_child(reset_btn)
		
		keybind_list.add_child(row)


func _get_action_display(action: String) -> String:
	var events = InputMap.action_get_events(action)
	if events.is_empty():
		return "—"
	var event = events[0]
	if event is InputEventKey:
		var key = event.physical_keycode if event.physical_keycode != 0 else event.keycode
		return OS.get_keycode_string(key)
	elif event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT: return "LMB"
			MOUSE_BUTTON_RIGHT: return "RMB"
			MOUSE_BUTTON_MIDDLE: return "MMB"
			_: return "Mouse %d" % event.button_index
	return str(event)


func _start_listening(action: String, button: Button) -> void:
	if listening_button:
		listening_button.text = _get_action_display(listening_for_action)
	
	listening_for_action = action
	listening_button = button
	button.text = "Drücke Taste..."


func _input(event: InputEvent) -> void:
	if listening_for_action == "":
		return
	if not visible:
		return
	
	if event is InputEventKey and event.pressed:
		_bind_event(event)
		accept_event()
	elif event is InputEventMouseButton and event.pressed:
		_bind_event(event)
		accept_event()


func _bind_event(event: InputEvent) -> void:
	InputMap.action_erase_events(listening_for_action)
	InputMap.action_add_event(listening_for_action, event)
	
	listening_button.text = _get_action_display(listening_for_action)
	listening_for_action = ""
	listening_button = null
	
	if SaveManager.has_method("save_keybinds"):
		SaveManager.save_keybinds()


func _reset_keybind(action: String, button: Button) -> void:
	if not DEFAULTS.has(action):
		return
	
	InputMap.action_erase_events(action)
	var entry = DEFAULTS[action]
	
	if entry.type == "key":
		var event = InputEventKey.new()
		event.physical_keycode = entry.value
		InputMap.action_add_event(action, event)
	elif entry.type == "mouse":
		var event = InputEventMouseButton.new()
		event.button_index = entry.value
		InputMap.action_add_event(action, event)
	
	button.text = _get_action_display(action)
	
	if SaveManager.has_method("save_keybinds"):
		SaveManager.save_keybinds()


func _on_reset_pressed() -> void:
	_perform_reset()


func _perform_reset() -> void:
	var save_dir = "user://saves/"
	var dir = DirAccess.open(save_dir)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				dir.remove(file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	
	if SaveManager.inventory:
		for i in range(SaveManager.inventory.slots.size()):
			SaveManager.inventory.slots[i] = null
		if "equipped" in SaveManager.inventory:
			for key in SaveManager.inventory.equipped.keys():
				SaveManager.inventory.equipped[key] = null
	
	SaveManager.player = PlayerSaveFile.new()
	SaveManager.museum = MuseumsSaveFile.new()
	if SaveManager.has_method("_ensure_showcases"):
		SaveManager._ensure_showcases()
	
	SaveManager.save_all()
	
	reset_button.text = "Reset durchgeführt — Spiel wird neu geladen..."
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()
