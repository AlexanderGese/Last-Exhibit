extends Control

@export var slot_type: String = ""
@onready var icon = $Icon

func refresh_icon() -> void:
	var item = SaveManager.player.equipped.get(slot_type)
	if item and item.icon:
		icon.texture = item.icon
		icon.visible = true
	else:
		icon.texture = null
		icon.visible = false
