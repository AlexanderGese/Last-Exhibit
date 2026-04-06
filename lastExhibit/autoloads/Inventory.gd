extends Node

const MAX_SLOTS = 15
var items: Array = []  # Array von ItemData oder null

func _ready() -> void:
	items.resize(MAX_SLOTS)

func add(item: ItemData) -> bool:
	for i in items.size():
		if items[i] == null:
			items[i] = item
			return true
	return false  # voll

func remove(index: int) -> void:
	items[index] = null

func get_item(index: int) -> ItemData:
	return items[index]
