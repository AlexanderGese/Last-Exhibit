extends Node

signal inventory_changed
signal item_dropped(item: Item)

var player: PlayerSaveFile
var museum: MuseumsSaveFile
var achievements: AchievmentSaveFile

var inventory: Inventory = preload("res://player_inventory.tres")


func _ready() -> void:
	load_all(0)

func save_all(slot: int) -> void:
	player.save(slot)
	museum.save(slot)

func load_all(slot: int) -> void:
	player = SaveFile.load_slot(slot, "PlayerSaveFile") as PlayerSaveFile
	if player == null:
		player = PlayerSaveFile.new()
	museum = SaveFile.load_slot(slot, "MuseumsSaveFile") as MuseumsSaveFile
	if museum == null:
		museum = MuseumsSaveFile.new()


# ── Inventory façade — alle Mutationen laufen hier durch und emiten Node-Signal ──

func use_item(index: int) -> bool:
	var slot = inventory.slots[index]
	if slot == null:
		return false
	
	var item: Item = slot.item
	if item.type != Item.Type.CONSUMABLE:
		return false
	
	if item.heal_amount > 0:
		var player = get_tree().get_first_node_in_group("player")
		if player and player.has_method("heal"):
			player.heal(item.heal_amount)
	
	slot.qty -= 1
	if slot.qty <= 0:
		inventory.slots[index] = null
	
	inventory_changed.emit()
	return true


func add_item(item: Item, qty: int = 1) -> bool:
	var ok := inventory.add_item(item, qty)
	if ok:
		inventory_changed.emit()
	return ok

func remove_item(index: int) -> void:
	inventory.remove_item(index)
	inventory_changed.emit()

func equip(index: int) -> void:
	inventory.equip(index)
	inventory_changed.emit()


# Pickup-Logik:
# - Equipment-Typ → wird sofort angelegt; ein bereits angelegtes Item gleichen Slots droppt.
# - sonst → normal ins Inventar; wenn voll = false (Pickup bleibt liegen).
func try_pickup(item: Item) -> bool:
	var key := inventory.equip_key(item.type)
	if key != "":
		var prev = inventory.equipped[key]
		inventory.equipped[key] = item
		inventory_changed.emit()
		if prev:
			item_dropped.emit(prev)
		return true

	var ok := inventory.add_item(item)
	if ok:
		inventory_changed.emit()
	return ok


# Wirft 1 Stück aus Slot. Spawnt es als Pickup (Player hört auf item_dropped).
func drop_item(slot_index: int) -> void:
	var slot = inventory.slots[slot_index]
	if slot == null:
		return
	var item: Item = slot.item
	if slot.qty > 1:
		slot.qty -= 1
	else:
		inventory.slots[slot_index] = null
	inventory_changed.emit()
	item_dropped.emit(item)
