extends PanelContainer

@export var slot_index: int = 0

@onready var icon: TextureRect = $Icon
@onready var qty_label: Label = $QuantityLabel


func refresh() -> void:
	var slot = SaveManager.inventory.slots[slot_index]
	if slot == null:
		icon.texture = null
		qty_label.text = ""
	else:
		icon.texture = slot.item.icon
		qty_label.text = str(slot.qty) if slot.qty > 1 else ""


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
			SaveManager.equip(slot_index)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			SaveManager.drop_item(slot_index)
