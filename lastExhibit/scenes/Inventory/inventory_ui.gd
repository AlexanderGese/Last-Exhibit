extends Control

@onready var slots: Array = $InventoryPanel/VBoxContainer.get_children().filter(
	func(c): return c is PanelContainer
)
@onready var equip_icons := {
	"head": $EquipmentPanel/VBoxContainer/HeadSlot/Icon,
	"body": $EquipmentPanel/VBoxContainer/BodySlot/Icon,
	"legs": $EquipmentPanel/VBoxContainer/LegsSlot/Icon,
	"feet": $EquipmentPanel/VBoxContainer/FeetSlot/Icon,
	"weapon": $EquipmentPanel/VBoxContainer/WeaponSlot/Icon,
}


func _ready() -> void:
	for i in slots.size():
		slots[i].slot_index = i

	SaveManager.inventory_changed.connect(refresh)
	refresh()


func refresh() -> void:
	var inv := SaveManager.inventory
	for slot in slots:
		slot.refresh()
	for key in equip_icons:
		equip_icons[key].texture = inv.equipped[key].icon if inv.equipped[key] else null


func _input(event: InputEvent) -> void:
	for i in 7:
		if event.is_action_pressed("hotkey_%d" % (i + 1)):
			var slot = SaveManager.inventory.slots[i]
			if slot == null:
				continue
			# Consumable → trinken, sonst → equippen
			if slot.item.type == Item.Type.CONSUMABLE:
				SaveManager.use_item(i)
			else:
				SaveManager.equip_from_inventory(i)
