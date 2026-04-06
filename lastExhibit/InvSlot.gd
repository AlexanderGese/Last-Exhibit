extends Control

var slot_index: int = 0

func _get_drag_data(_pos: Vector2) -> Variant:
	var item = Inventory.get_item(slot_index)
	if item == null:
		return null
	var preview = TextureRect.new()
	preview.texture = item.icon
	preview.size = Vector2(32, 32)
	preview.top_level = true  # NEU
	set_drag_preview(preview)
	return {"index": slot_index, "item": item}

func _can_drop_data(_pos: Vector2, data: Variant) -> bool:
	return data is Dictionary and data.has("item")

func _drop_data(_pos: Vector2, data: Variant) -> void:
	var from = data["index"]
	var from_item = data["item"]
	var to_item = Inventory.get_item(slot_index)
	Inventory.items[slot_index] = from_item
	if from >= 0:
		Inventory.items[from] = to_item
	get_tree().get_first_node_in_group("inventory_ui").refresh()
