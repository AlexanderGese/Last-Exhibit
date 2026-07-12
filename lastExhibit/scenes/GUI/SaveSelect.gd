extends Control

@onready var _slot_btns := [
	$Center/Panel/VBox/Slot1/AspectRatioContainer/Play,
	$Center/Panel/VBox/Slot2/AspectRatioContainer/Play,
	$Center/Panel/VBox/Slot3/AspectRatioContainer/Play,
]
@onready var _del_btns := [
	$Center/Panel/VBox/Slot1/AspectRatioContainer2/Delete,
	$Center/Panel/VBox/Slot2/AspectRatioContainer2/Delete,
	$Center/Panel/VBox/Slot3/AspectRatioContainer2/Delete,
]

const BUTTON_DATA = [
	{
		"texture_continue": preload("res://assets/sprites/GUI/Buttons_1big/button_05.png"),
		"region_continue": Rect2(3, 11, 58, 11),
		"texture_new": preload("res://assets/sprites/GUI/Buttons_1big/button_04.png"),
		"region_new": Rect2(3, 11, 58, 11)
	},
	{
		"texture_continue": preload("res://assets/sprites/GUI/Buttons_1big/button_07.png"),
		"region_continue": Rect2(3, 11, 58, 11),
		"texture_new": preload("res://assets/sprites/GUI/Buttons_1big/button_06.png"),
		"region_new": Rect2(3, 11, 58, 11)
	},
	{
		"texture_continue": preload("res://assets/sprites/GUI/Buttons_1big/button_09.png"),
		"region_continue": Rect2(3, 11, 58, 11),
		"texture_new": preload("res://assets/sprites/GUI/Buttons_1big/button_08.png"),
		"region_new": Rect2(3, 11, 58, 11)
	}
]

func _ready() -> void:
	visible = false
	$Center/Panel/VBox/AspectRatioContainer/Back.pressed.connect(close)
	for i in 3:
		_slot_btns[i].pressed.connect(_start.bind(i))
		_del_btns[i].pressed.connect(_delete.bind(i))


func open() -> void:
	visible = true
	_refresh()


func close() -> void:
	visible = false


func _refresh() -> void:
	for i in 3:
		var exists: bool = SaveManager.has_save(i)
		var data = BUTTON_DATA[i]
		
		_slot_btns[i].text = ""
		
		var current_stylebox = _slot_btns[i].get_theme_stylebox("normal") as StyleBoxTexture
		
		if current_stylebox:
			var new_stylebox = current_stylebox.duplicate() as StyleBoxTexture
			
			if exists:
				new_stylebox.texture = data["texture_continue"]
				new_stylebox.region_rect = data["region_continue"]
			else:
				new_stylebox.texture = data["texture_new"]
				new_stylebox.region_rect = data["region_new"]
				
			_slot_btns[i].add_theme_stylebox_override("normal", new_stylebox)
			_slot_btns[i].add_theme_stylebox_override("hover", new_stylebox)
			_slot_btns[i].add_theme_stylebox_override("pressed", current_stylebox)
		
		_del_btns[i].visible = exists


#func _start(slot: int) -> void:
	#SaveManager.load_game(slot)
	#get_tree().change_scene_to_file("res://scenes/Museum/Museum.tscn")

func _start(slot: int) -> void:
	var is_new_game: bool = not SaveManager.has_save(slot)
	SaveManager.load_game(slot)
	if is_new_game:
		get_tree().change_scene_to_file("res://scenes/GUI/Intro1.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/Museum/Museum.tscn")

func _delete(slot: int) -> void:
	SaveManager.reset_slot(slot)
	_refresh()
