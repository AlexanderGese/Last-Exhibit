extends Control

@export var slot_type: String = ""
@onready var icon = $Icon

func _get_drag_data(_pos: Vector2) -> Variant:
	var item = SaveManager.player.equipped.get(slot_type)
	if item == null:
		return null
	var preview = TextureRect.new()
	preview.texture = icon.texture
	preview.size = Vector2(48, 48)
	set_drag_preview(preview)
	return {"index": -1, "item": item, "from_equip": slot_type}

func _can_drop_data(_pos: Vector2, data: Variant) -> bool:
	if not data is Dictionary:
		return false
	var item = data["item"] as ItemData
	return item.equip_slot == slot_type

func _drop_data(_pos: Vector2, data: Variant) -> void:
	var item = data["item"] as ItemData
	# altes Item zurück ins Inventar
	var old = SaveManager.player.equipped.get(slot_type)
	if old != null:
		Inventory.add(old)
	# neues Item equippen
	SaveManager.player.equipped[slot_type] = item
	# aus Inventar entfernen wenn es von dort kam
	if data.has("index") and data["index"] >= 0:
		Inventory.items[data["index"]] = null
	get_tree().get_first_node_in_group("inventory_ui").refresh()
	refresh_icon()

func refresh_icon() -> void:
	var item = SaveManager.player.equipped.get(slot_type)
	if item and item.icon:
		icon.texture = item.icon
		icon.visible = true
	else:
		icon.texture = null
		icon.visible = false
