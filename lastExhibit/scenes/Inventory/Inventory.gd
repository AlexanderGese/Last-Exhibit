extends Control

@onready var slots = $Panel/ItemSlots.get_children()
@onready var equip_slots = {
	"waffe":     $Panel/EquipSlots/SlotWaffe/Icon,
	"helm":      $Panel/EquipSlots/SlotHelm/Icon,
	"oberteil":  $Panel/EquipSlots/SlotOberteil/Icon,
	"hose":      $Panel/EquipSlots/SlotHose/Icon,
	"schmuck1":  $Panel/EquipSlots/SlotSchmuck1/Icon,
	"schmuck2":  $Panel/EquipSlots/SlotSchmuck2/Icon,
}

func _ready() -> void:
	add_to_group("inventory_ui")
	for i in slots.size():
		slots[i].slot_index = i
	hide()
	refresh()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		if visible:
			hide()
		else:
			show()
			refresh()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			_drop_item_at_mouse()
			
			
func _drop_item_at_mouse() -> void:
	for i in slots.size():
		if slots[i].get_global_rect().has_point(get_global_mouse_position()):
			var item = Inventory.get_item(i)
			if item == null:
				return
			# Artefakt in der Welt spawnen
			var pickup = preload("res://custom_nodes/ItemPickUp/ItemPickup.tscn").instantiate()
			pickup.item_data = item
			pickup.global_position = get_tree().get_first_node_in_group("player").global_position
			get_tree().current_scene.add_child(pickup)
			Inventory.remove(i)
			refresh()
			return
func refresh() -> void:
	for i in slots.size():
		slots[i].slot_index = i
		var icon = slots[i].get_node("Icon")
		var item = Inventory.get_item(i)
		if item and item.icon:
			icon.texture = item.icon
			icon.visible = true
		else:
			icon.texture = null
			icon.visible = false
			
