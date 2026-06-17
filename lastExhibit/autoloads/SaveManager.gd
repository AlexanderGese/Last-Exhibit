extends Node

signal inventory_changed
signal item_dropped(item: Item)

var player: PlayerSaveFile
var museum: MuseumsSaveFile
var achievements: AchievmentSaveFile
var inventory: Inventory = preload("res://saves/player_inventory.tres")
var player_char
const SHOWCASE_COUNT = 45


func _ready() -> void:
	load_all(0)
	Events.artifact_place.connect(remove_item_from_inv)
	player_char = get_tree().get_first_node_in_group("player")
	Events.upgrade_collected.connect(install_upgrade)
	load_keybinds()

func save_keybinds() -> void:
	var data = {}
	for action in InputMap.get_actions():
		if action.begins_with("ui_"):
			continue
		var events = InputMap.action_get_events(action)
		if events.is_empty():
			continue
		var event = events[0]
		if event is InputEventKey:
			data[action] = {"type": "key", "key": event.physical_keycode}
		elif event is InputEventMouseButton:
			data[action] = {"type": "mouse", "button": event.button_index}
	
	var file = FileAccess.open("user://keybinds.dat", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))


func load_keybinds() -> void:
	if not FileAccess.file_exists("user://keybinds.dat"):
		return
	var file = FileAccess.open("user://keybinds.dat", FileAccess.READ)
	if not file:
		return
	var data = JSON.parse_string(file.get_as_text())
	if data == null or typeof(data) != TYPE_DICTIONARY:
		return
	
	for action in data.keys():
		var entry = data[action]
		if not InputMap.has_action(action):
			continue
		InputMap.action_erase_events(action)
		if entry.type == "key":
			var event = InputEventKey.new()
			event.physical_keycode = int(entry.key)
			InputMap.action_add_event(action, event)
		elif entry.type == "mouse":
			var event = InputEventMouseButton.new()
			event.button_index = int(entry.button)
			InputMap.action_add_event(action, event)	
	
func install_upgrade(type: String):
	if type == "WW2":
		SaveManager.player.unlocked_epochs.append("ww2")
	elif type == "Medieval":
		SaveManager.player.unlocked_epochs.append("mittelalter")
	elif type == "Time":
		SaveManager.player.level_time += 30
	elif type == "japan":
		SaveManager.player.unlocked_epochs.append("japan")
		
		
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
	
	_ensure_showcases()
	

func _ensure_showcases() -> void:
	
	while museum.showcases.size() < SHOWCASE_COUNT:
		museum.showcases.append(null)
	

func buy(price: float, item: String, currency: String)-> bool:
	var this: bool = player.buy(int(price), item, currency)
	save_all(0)
	return this



# ── Inventory façade — alle Mutationen laufen hier durch und emiten Node-Signal ──

func use_item(index: int) -> bool:
	var slot = inventory.slots[index]
	if slot == null:
		return false
	var item: Item = slot.item
	if item.type == Item.Type.CONSUMABLE:
		return consumable(item, slot, index)
	elif item.type == Item.Type.ARTIFACT:
		return artifact(item,slot,index)
	return false
	
func consumable(item: Item, slot, index: int) -> bool:
	# Player_char immer frisch holen (Autoload startet vor Player)
	if player_char == null or not is_instance_valid(player_char):
		player_char = get_tree().get_first_node_in_group("player")
	
	if player_char == null or not player_char.has_method("heal"):
		print("Kein Player gefunden zum Heilen")
		return false
	
	if item.heal_amount <= 0:
		return false
	
	var healed = player_char.heal(item.heal_amount)
	if not healed:
		return false
	
	slot.qty -= 1
	if slot.qty <= 0:
		inventory.slots[index] = null
	inventory_changed.emit()
	return true
	
	
func artifact(item: Item, slot, index:int) -> bool:
	Events.used_artifact.emit(item, index)
	return true
	
func remove_item_from_inv(i: int):
	var slot = inventory.slots[i]
	slot.qty -= 1
	if slot.qty <= 0:
		inventory.slots[i] = null
		inventory_changed.emit()
	pass
	
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
		
		if key == "weapon":
			Events.weapon_changed.emit(item.id)
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
