extends Control

@onready var slots = $Panel/ItemSlots.get_children()
@onready var equip_slot_nodes: Array[Control] = [
	$Panel/EquipSlots/SlotWaffe,
	$Panel/EquipSlots/SlotHelm,
	$Panel/EquipSlots/SlotOberteil,
	$Panel/EquipSlots/SlotHose,
	$Panel/EquipSlots/SlotSchmuck1,
	$Panel/EquipSlots/SlotSchmuck2,
]

# Drag State
var held_item: ItemData = null
var held_from_inv: int = -1        # Index im Inventar, oder -1
var held_from_equip: String = ""   # Equip-Slot Name, oder ""
var drag_preview: TextureRect = null

func _ready() -> void:
	add_to_group("inventory_ui")
	for i in slots.size():
		slots[i].slot_index = i
	# Preview-Node vorbereiten
	drag_preview = TextureRect.new()
	drag_preview.size = Vector2(32, 32)
	drag_preview.z_index = 100
	drag_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	drag_preview.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	drag_preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	drag_preview.visible = false
	drag_preview.top_level = true
	add_child(drag_preview)
	hide()
	refresh()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		if visible:
			_cancel_drag()
			hide()
		else:
			show()
			refresh()

	if not visible:
		return

	if Input.is_action_just_pressed("left_click"):
		_handle_click()

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		_drop_item_at_mouse()

func _process(_delta: float) -> void:
	if held_item and drag_preview.visible:
		drag_preview.global_position = get_global_mouse_position() - drag_preview.size / 2

func _is_mouse_over(control: Control) -> bool:
	var local = control.get_local_mouse_position()
	return Rect2(Vector2.ZERO, control.size).has_point(local)

func _handle_click() -> void:
	# Prüfe Inventar-Slots
	for i in slots.size():
		var icon_node = slots[i].get_node("Icon")
		if _is_mouse_over(icon_node):
			_click_inv_slot(i)
			return

	# Prüfe Equip-Slots
	for eq_node in equip_slot_nodes:
		if _is_mouse_over(eq_node) or _is_mouse_over(eq_node.get_node("Icon")):
			_click_equip_slot(eq_node)
			return

	# Klick außerhalb -> Item in die Welt droppen
	_drop_held_to_world()

func _click_inv_slot(index: int) -> void:
	if held_item == null:
		# Aufheben
		var item = Inventory.get_item(index)
		if item == null:
			return
		held_item = item
		held_from_inv = index
		held_from_equip = ""
		Inventory.items[index] = null
		_start_preview()
	else:
		# Ablegen / Tauschen
		var target_item = Inventory.get_item(index)
		Inventory.items[index] = held_item
		if target_item:
			# Tauschen: altes Item wird zum neuen held
			held_item = target_item
			_start_preview()
		else:
			_stop_drag()
	refresh()

func _click_equip_slot(eq_node: Control) -> void:
	var slot_type: String = eq_node.slot_type
	if held_item == null:
		# Aus Equip aufheben
		var equipped = SaveManager.player.equipped.get(slot_type)
		if equipped == null:
			return
		held_item = equipped
		held_from_inv = -1
		held_from_equip = slot_type
		SaveManager.player.equipped.erase(slot_type)
		eq_node.refresh_icon()
		_start_preview()
	else:
		# In Equip ablegen
		if held_item.equip_slot != slot_type:
			return  # Passt nicht in diesen Slot
		var old_equipped = SaveManager.player.equipped.get(slot_type)
		SaveManager.player.equipped[slot_type] = held_item
		if old_equipped:
			held_item = old_equipped
			_start_preview()
		else:
			_stop_drag()
		eq_node.refresh_icon()
	refresh()

func _start_preview() -> void:
	drag_preview.texture = held_item.icon
	drag_preview.visible = true

func _stop_drag() -> void:
	held_item = null
	held_from_inv = -1
	held_from_equip = ""
	drag_preview.visible = false
	drag_preview.texture = null

func _spawn_pickup(item: ItemData) -> void:
	var pickup = preload("res://custom_nodes/ItemPickUp/ItemPickup.tscn").instantiate()
	pickup.item_data = item
	pickup.global_position = get_tree().get_first_node_in_group("player").global_position
	get_tree().current_scene.add_child(pickup)
	pickup.disable_pickup_temporarily(5.0)

func _drop_held_to_world() -> void:
	if held_item == null:
		return
	_spawn_pickup(held_item)
	_stop_drag()
	refresh()

func _cancel_drag() -> void:
	if held_item == null:
		return
	if held_from_inv >= 0:
		Inventory.items[held_from_inv] = held_item
	elif held_from_equip != "":
		SaveManager.player.equipped[held_from_equip] = held_item
		for eq_node in equip_slot_nodes:
			if eq_node.slot_type == held_from_equip:
				eq_node.refresh_icon()
	else:
		Inventory.add(held_item)
	_stop_drag()
	refresh()

func _drop_item_at_mouse() -> void:
	# Wenn wir gerade ein Item halten -> das in die Welt droppen
	if held_item:
		_drop_held_to_world()
		return
	# Sonst: Rechtsklick auf einen Slot -> direkt droppen
	for i in slots.size():
		var icon_node = slots[i].get_node("Icon")
		if _is_mouse_over(icon_node):
			var item = Inventory.get_item(i)
			if item == null:
				return
			_spawn_pickup(item)
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
	for eq_node in equip_slot_nodes:
		eq_node.refresh_icon()
