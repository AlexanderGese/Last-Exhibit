extends Node2D

@onready var big_item: Sprite2D = $BigShowcase/Item
@onready var small_item: Sprite2D = $SmallShowcase/Item
@onready var big_showcase: Node2D = $BigShowcase
@onready var small_showcase: Node2D = $SmallShowcase
@onready var big_label: Label = $BigShowcase/Label
@onready var small_label: Label = $SmallShowcase/Label
@onready var color_rect: ColorRect = $ColorRect
@onready var empty_label: Label = $Label

@export var number: int
@export var showcaseroom: int

var player_is_detected: bool = false
var data: Showcase = null


func _ready() -> void:
	Events.used_artifact.connect(placeshowcase)
	_load_or_create_data()
	_refresh_visuals()
	_refresh_empty_overlay()


# Manuell aufrufen wenn alles geresettet werden soll (NICHT in _ready!)
func reset_all_showcases() -> void:
	SaveManager.museum.showcases.clear()
	SaveManager.museum.showcases.resize(45)
	SaveManager.museum.showroom.clear()
	SaveManager.museum.showroom.resize(5)
	for i in range(5):
		SaveManager.museum.showroom[i] = ""
	SaveManager.save_all()
	print("Alle Showcases + Showrooms resettet")


func _process(_delta: float) -> void:
	if player_is_detected and data != null and not data.is_empty:
		if Input.is_action_just_pressed("interact"):
			pickup_artifact()


func _load_or_create_data() -> void:
	var idx = number - 1
	if idx < 0 or idx >= SaveManager.museum.showcases.size():
		return

	if SaveManager.museum.showcases[idx] == null:
		var new_data = Showcase.new()
		new_data.is_empty = true
		SaveManager.museum.showcases[idx] = new_data

	data = SaveManager.museum.showcases[idx]


func _refresh_visuals() -> void:
	big_showcase.visible = false
	small_showcase.visible = false

	if data == null or data.is_empty:
		return

	if data.big_artifact:
		big_showcase.visible = true
		big_item.texture = data.icon
		big_item.visible = true
		big_label.text = "x%d" % data.qty
	else:
		small_showcase.visible = true
		small_item.texture = data.icon
		small_item.visible = true
		small_label.text = "x%d" % data.qty


func _refresh_empty_overlay() -> void:
	# ColorRect + Label zeigen "leer"-Status
	var is_filled = data != null and not data.is_empty
	color_rect.visible = not is_filled
	empty_label.visible = not is_filled


func placeshowcase(item: Item, index: int) -> void:
	if not player_is_detected:
		return
	if data == null:
		return

	# Showroom-Check: wenn Raum schon eine Origin hat, muss Item passen
	var room_idx = showcaseroom - 1
	if room_idx < 0 or room_idx >= SaveManager.museum.showroom.size():
		push_warning("[Showcase #%d] Ungültiger showroom-Index: %d" % [number, showcaseroom])
		return

	var current_origin = SaveManager.museum.showroom[room_idx]
	if current_origin != null and current_origin != "" and current_origin != item.origin:
		print(
			"[Showcase #",
			number,
			"] Raum ist '",
			current_origin,
			"', Item ist '",
			item.origin,
			"' → blockiert"
		)
		return

	# Placement
	if data.is_empty:
		data.is_empty = false
		data.icon = item.icon
		data.value = item.value
		data.big_artifact = item.big_artifact
		data.item = item
		data.qty = 1
	elif data.item == item:
		data.qty += 1
	else:
		return

	# Showroom-Origin merken
	SaveManager.museum.showroom[room_idx] = item.origin
	Events.new_floor.emit(item.origin, showcaseroom)
	_refresh_visuals()
	_refresh_empty_overlay()
	Events.artifact_place.emit(index)
	SaveManager.save_all()
	_on_item_added(item)


func pickup_artifact() -> void:
	if data == null or data.is_empty:
		return
	if data.item == null:
		return

	var picked_item = data.item

	if not SaveManager.try_pickup(data.item):
		return

	data.qty -= 1
	if data.qty <= 0:
		_reset_showcase()
	else:
		_refresh_visuals()
		SaveManager.save_all()

	_on_item_removed(picked_item)


func _reset_showcase() -> void:
	data.is_empty = true
	data.icon = null
	data.value = 0
	data.big_artifact = false
	data.item = null
	data.qty = 0
	_refresh_visuals()
	_refresh_empty_overlay()
	_maybe_clear_showroom()
	SaveManager.save_all()


func _maybe_clear_showroom() -> void:
	# Wenn keine Showcase mehr im selben Showroom befüllt ist, Origin löschen
	var room_idx = showcaseroom - 1
	if room_idx < 0 or room_idx >= SaveManager.museum.showroom.size():
		return

	# Check ob in diesem Raum noch andere Showcases mit Items existieren
	# Das müsstest du irgendwie tracken — z.B. über alle Showcase-Nodes iterieren
	# Für jetzt: einfach leer lassen, Raum nimmt nächstes Item beliebiger Origin an
	SaveManager.museum.showroom[room_idx] = ""


func _on_item_added(item: Item) -> void:
	SaveManager.museum.reputation += 1
	print("[Showcase #", number, "] Item hinzugefügt: ", item, " neue qty: ", data.qty)


func _on_item_removed(item: Item) -> void:
	SaveManager.museum.reputation = max(0, SaveManager.museum.reputation - 1)
	print("[Showcase #", number, "] Item entfernt: ", item, " verbleibend: ", data.qty)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_is_detected = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_is_detected = false
