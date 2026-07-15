extends Node

signal inventory_changed
signal item_dropped(item: Item)

var player: PlayerSaveFile
var museum: MuseumsSaveFile
var achievements: AchievmentSaveFile
var inventory: Inventory
var player_char
var current_slot: int = 0
const SHOWCASE_COUNT = 45


func _ready() -> void:
	load_all()
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
	match type:
		"WW2":
			_unlock_epoch("ww2")
		"Mittelalter":
			_unlock_epoch("mittelalter")
		"japan":
			_unlock_epoch("japan")
		"Time":
			player.level_time += 30
	save_all()


func _unlock_epoch(epoch: String) -> void:
	if not epoch in player.unlocked_epochs:
		player.unlocked_epochs.append(epoch)


func _inventory_path(slot: int) -> String:
	return SaveFile.SAVE_DIR + "slot_%d_Inventory" % slot + SaveFile.EXT


func save_all() -> void:
	player.save(current_slot)
	museum.save(current_slot)
	ResourceSaver.save(inventory, _inventory_path(current_slot))


func advance_day() -> int:
	museum.current_night += 1
	var income := museum.collect_daily_income()
	save_all()
	return income


func load_all() -> void:
	player = SaveFile.load_slot(current_slot, "PlayerSaveFile") as PlayerSaveFile
	if player == null:
		player = PlayerSaveFile.new()

	museum = SaveFile.load_slot(current_slot, "MuseumsSaveFile") as MuseumsSaveFile
	if museum == null:
		museum = MuseumsSaveFile.new()

	var inv_path := _inventory_path(current_slot)
	if FileAccess.file_exists(inv_path):
		inventory = ResourceLoader.load(inv_path, "", ResourceLoader.CACHE_MODE_IGNORE) as Inventory
	else:
		inventory = null
	if inventory == null:
		inventory = Inventory.new()

	_ensure_showcases()


func load_game(slot: int) -> void:
	current_slot = slot
	load_all()


func has_save(slot: int) -> bool:
	return FileAccess.file_exists(
		SaveFile.SAVE_DIR + "slot_%d_PlayerSaveFile" % slot + SaveFile.EXT
	)


func reset_all() -> void:
	var dir = DirAccess.open(SaveFile.SAVE_DIR)
	if dir:
		dir.list_dir_begin()
		var f = dir.get_next()
		while f != "":
			if not dir.current_is_dir():
				dir.remove(f)
			f = dir.get_next()
		dir.list_dir_end()
	current_slot = 0
	player = PlayerSaveFile.new()
	museum = MuseumsSaveFile.new()
	inventory = Inventory.new()
	_ensure_showcases()
	inventory_changed.emit()
	save_all()


func reset_slot(slot: int) -> void:
	for t in ["PlayerSaveFile", "MuseumsSaveFile", "Inventory"]:
		var p := SaveFile.SAVE_DIR + "slot_%d_%s" % [slot, t] + SaveFile.EXT
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)
	if slot == current_slot:
		load_all()


func _ensure_showcases() -> void:
	while museum.showcases.size() < SHOWCASE_COUNT:
		museum.showcases.append(null)


func buy(price: float, item: String, currency: String) -> bool:
	var this: bool = player.buy(int(price), item, currency)
	save_all()
	return this


func is_pickup_collected(id: String) -> bool:
	return id in player.collected_pickups


func collect_pickup(id: String) -> void:
	if id != "" and not id in player.collected_pickups:
		player.collected_pickups.append(id)
		save_all()


func is_shard_collected(id: String) -> bool:
	return id in player.collected_shards


func collect_shard(id: String, amount: int) -> bool:
	if id == "" or id in player.collected_shards:
		return false
	player.collected_shards.append(id)
	player.time_shards += amount
	save_all()
	return true


const SELL_MIN_VALUE := 1
const SELL_RATE := 0.1


func can_sell(item: Item) -> bool:
	return item != null and item.type == Item.Type.ARTIFACT and item.value >= SELL_MIN_VALUE


func artifact_btc_price(item: Item) -> int:
	return max(1, int(round(item.value * SELL_RATE)))


func sell_artifact(index: int) -> bool:
	var slot = inventory.slots[index]
	if slot == null or not can_sell(slot.item):
		return false
	var item: Item = slot.item
	var price := artifact_btc_price(item)
	player.btc += price
	player.add_transcation(item.name, price, "btc")
	slot.qty -= 1
	if slot.qty <= 0:
		inventory.slots[index] = null
	inventory_changed.emit()
	save_all()
	return true


# ── Inventory façade — alle Mutationen laufen hier durch und emiten Node-Signal ──


func use_item(index: int) -> bool:
	var slot = inventory.slots[index]
	if slot == null:
		return false
	var item: Item = slot.item
	if item.type == Item.Type.CONSUMABLE:
		return consumable(item, slot, index)
	elif item.type == Item.Type.ARTIFACT:
		return artifact(item, slot, index)
	return false


func consumable(item: Item, slot, index: int) -> bool:
	if not _apply_effect(item):
		return false
	slot.qty -= 1
	if slot.qty <= 0:
		inventory.slots[index] = null
	inventory_changed.emit()
	return true


func _player_char():
	if player_char == null or not is_instance_valid(player_char):
		player_char = get_tree().get_first_node_in_group("player")
	return player_char


func _apply_effect(item: Item) -> bool:
	var p = _player_char()
	match item.effect:
		"heal":
			return p != null and p.heal(int(item.effect_amount))
		"regen":
			if p == null:
				return false
			p.start_regen(item.effect_amount, item.effect_duration)
			return true
		"adrenaline":
			if p == null:
				return false
			p.adrenaline(item.effect_amount, item.effect_duration)
			return true
		"time_slow":
			if p == null:
				return false
			p.time_slow(item.effect_amount, item.effect_duration)
			return true
		"extend_timer":
			return p != null and p.extend_level_time(item.effect_amount)
		"molotov":
			return p != null and p.throw_molotov()
		"emp":
			_emp(item.effect_duration)
			return true
		"overclock":
			player.combo_bonus += int(item.effect_amount)
			save_all()
			return true
		"second_wind":
			return false
		_:
			return p != null and item.heal_amount > 0 and p.heal(int(item.heal_amount))


func _emp(duration: float) -> void:
	var enemies = get_tree().get_nodes_in_group("enemy")
	for e in enemies:
		if is_instance_valid(e):
			e.set_physics_process(false)
	await get_tree().create_timer(duration).timeout
	for e in enemies:
		if is_instance_valid(e):
			e.set_physics_process(true)


func consume_effect_item(effect: String) -> bool:
	for i in inventory.slots.size():
		var s = inventory.slots[i]
		if s != null and s.item != null and s.item.effect == effect:
			s.qty -= 1
			if s.qty <= 0:
				inventory.slots[i] = null
			inventory_changed.emit()
			return true
	return false


func artifact(item: Item, slot, index: int) -> bool:
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


func clear_inventory() -> void:
	for i in inventory.slots.size():
		inventory.slots[i] = null
	inventory_changed.emit()
	save_all()


func equip(index: int) -> void:
	inventory.equip(index)
	inventory_changed.emit()


# Pickup-Logik:
# - Equipment-Typ → wird sofort angelegt; ein bereits angelegtes Item gleichen Slots droppt.
# - sonst → normal ins Inventar; wenn voll = false (Pickup bleibt liegen).


func try_pickup(item: Item) -> bool:
	if item == null:
		return false
	if item.type == Item.Type.ARTIFACT:
		Tutorials.show_tutorial("first_artifact")
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
