extends Control

@onready var _slot_btns := [
	$Center/Panel/VBox/Slot1/Play,
	$Center/Panel/VBox/Slot2/Play,
	$Center/Panel/VBox/Slot3/Play,
]
@onready var _del_btns := [
	$Center/Panel/VBox/Slot1/Delete,
	$Center/Panel/VBox/Slot2/Delete,
	$Center/Panel/VBox/Slot3/Delete,
]


func _ready() -> void:
	visible = false
	$Center/Panel/VBox/Back.pressed.connect(close)
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
		_slot_btns[i].text = "Slot %d  -  %s" % [i + 1, "Continue" if exists else "New Game"]
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
