class_name Inventory
extends Resource

const SIZE := 7

@export var slots: Array = []
@export var equipped := {"head": null, "body": null, "legs": null, "feet": null, "weapon": null}
@export var gold: int = 0


func _init() -> void:
	if slots.is_empty():
		slots.resize(SIZE)


func add_item(item: Item, qty: int = 1) -> bool:
	var remaining := qty

	if item.stackable:
		for slot in slots:
			if remaining <= 0:
				break
			if slot and slot.item.id == item.id and slot.qty < item.max_stack:
				var space: int = item.max_stack - slot.qty
				var take: int = min(space, remaining)
				slot.qty += take
				remaining -= take

	for i in SIZE:
		if remaining <= 0:
			break
		if slots[i] == null:
			var stack_cap: int = item.max_stack if item.stackable else 1
			var take: int = min(stack_cap, remaining)
			slots[i] = {"item": item, "qty": take}
			remaining -= take

	return remaining == 0


func remove_item(index: int) -> void:
	slots[index] = null


func equip(index: int) -> void:
	var slot = slots[index]
	if slot == null:
		return

	var key := equip_key(slot.item.type)
	if key == "":
		return

	var prev = equipped[key]
	equipped[key] = slot.item
	slots[index] = {"item": prev, "qty": 1} if prev else null


func equip_key(type: int) -> String:
	match type:
		Item.Type.HEAD: return "head"
		Item.Type.BODY: return "body"
		Item.Type.LEGS: return "legs"
		Item.Type.FEET: return "feet"
		Item.Type.WEAPON: return "weapon"
	return ""
