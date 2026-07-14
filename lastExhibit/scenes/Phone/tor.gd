extends TextureRect

const FONT = preload("res://assets/fonts/Pixuf.ttf")

const COL_INK      := Color("f5f1ff")
const COL_MUTED    := Color("b3a9cf")
const COL_PURPLE   := Color("b98cff")
const COL_BTC      := Color("ffab2e")
const COL_PANEL    := Color("1a1428")
const COL_BTN      := Color("2c2142")
const COL_BTN_HOV  := Color("3b2b5a")

const CATALOG: Array = [
	{"path": "res://inventory/items/blackmarket/street_stim.tres", "price": 5},
	{"path": "res://inventory/items/blackmarket/painkillers.tres", "price": 8},
	{"path": "res://inventory/items/blackmarket/molotov.tres", "price": 10},
	{"path": "res://inventory/items/blackmarket/adrenaline_shot.tres", "price": 12},
	{"path": "res://inventory/items/blackmarket/temporal_anchor.tres", "price": 15},
	{"path": "res://inventory/items/blackmarket/emp_charge.tres", "price": 20},
	{"path": "res://inventory/items/blackmarket/time_serum.tres", "price": 25},
	{"path": "res://inventory/items/blackmarket/second_wind.tres", "price": 60},
	{"path": "res://inventory/items/blackmarket/overclock_chip.tres", "price": 250},
]

var _btc_label: Label
var _sell_list: VBoxContainer
var _buy_list: VBoxContainer


func _ready() -> void:
	_build_ui()
	SaveManager.inventory_changed.connect(_refresh)
	visibility_changed.connect(_on_visibility_changed)
	_refresh()


func _on_visibility_changed() -> void:
	if visible:
		_refresh()


func _build_ui() -> void:
	var root := VBoxContainer.new()
	root.anchor_left = 0.192
	root.anchor_top = 0.220
	root.anchor_right = 0.821
	root.anchor_bottom = 0.787
	root.add_theme_constant_override("separation", 8)
	add_child(root)

	var chip := PanelContainer.new()
	chip.add_theme_stylebox_override("panel", _panel_box(COL_PANEL, COL_BTC, 0.8))
	var chip_row := HBoxContainer.new()
	var tag := _label("BALANCE", 13, COL_MUTED)
	tag.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tag.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	chip_row.add_child(tag)
	_btc_label = _label("", 20, COL_BTC)
	chip_row.add_child(_btc_label)
	chip.add_child(chip_row)
	root.add_child(chip)

	_add_header(root, "// SELL")
	_sell_list = _scroll_list(root)

	_add_header(root, "// BUY")
	_buy_list = _scroll_list(root)


func _add_header(parent: Node, text: String) -> void:
	parent.add_child(_label(text, 16, COL_PURPLE))
	var rule := ColorRect.new()
	rule.color = Color(COL_PURPLE, 0.55)
	rule.custom_minimum_size = Vector2(0, 2)
	parent.add_child(rule)


func _scroll_list(parent: Node) -> VBoxContainer:
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	parent.add_child(scroll)
	var list := VBoxContainer.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.add_theme_constant_override("separation", 5)
	scroll.add_child(list)
	return list


func _add_row(list: VBoxContainer, left: String, price_btc: int, action: String) -> Button:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _panel_box(COL_PANEL, COL_PURPLE, 0.35))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	panel.add_child(row)

	var name_l := _label(left, 14, COL_INK)
	name_l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_l.clip_text = true
	name_l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	row.add_child(name_l)

	var price_l := _label("%d BTC" % price_btc, 14, COL_BTC)
	price_l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	row.add_child(price_l)

	var btn := Button.new()
	btn.text = action
	_style_button(btn)
	row.add_child(btn)

	list.add_child(panel)
	return btn


func _refresh() -> void:
	if _btc_label == null:
		return
	_btc_label.text = "%d BTC" % SaveManager.player.btc
	_rebuild_sell()
	_rebuild_buy()


func _clear(container: Node) -> void:
	for c in container.get_children():
		c.queue_free()


func _rebuild_sell() -> void:
	_clear(_sell_list)
	var any := false
	for i in SaveManager.inventory.slots.size():
		var slot = SaveManager.inventory.slots[i]
		if slot == null or not SaveManager.can_sell(slot.item):
			continue
		any = true
		var label := "%s  x%d" % [slot.item.name, slot.qty]
		var btn := _add_row(_sell_list, label, SaveManager.artifact_btc_price(slot.item), "Sell")
		btn.pressed.connect(_on_sell.bind(i))
	if not any:
		_sell_list.add_child(_muted("No sellable artifacts in your bag."))


func _rebuild_buy() -> void:
	_clear(_buy_list)
	if CATALOG.is_empty():
		_buy_list.add_child(_muted("No listings right now."))
		return
	for entry in CATALOG:
		var item: Item = load(entry.path)
		var btn := _add_row(_buy_list, item.name, entry.price, "Buy")
		btn.disabled = SaveManager.player.btc < entry.price
		btn.pressed.connect(_on_buy.bind(entry))


func _on_sell(index: int) -> void:
	SaveManager.sell_artifact(index)


func _on_buy(entry) -> void:
	var item: Item = load(entry.path)
	if SaveManager.player.btc < entry.price:
		return
	if not SaveManager.add_item(item):
		return
	SaveManager.buy(entry.price, item.name, "btc")
	_refresh()


func _label(text: String, size: int, color: Color) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_override("font", FONT)
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	return l


func _muted(text: String) -> Label:
	var l := _label(text, 13, COL_MUTED)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD
	return l


func _panel_box(bg: Color, border: Color, border_alpha: float) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.set_corner_radius_all(4)
	s.set_border_width_all(1)
	s.border_color = Color(border, border_alpha)
	s.set_content_margin_all(6)
	return s


func _btn_box(bg: Color, border: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.set_corner_radius_all(3)
	s.set_border_width_all(1)
	s.border_color = border
	s.content_margin_left = 9
	s.content_margin_right = 9
	s.content_margin_top = 4
	s.content_margin_bottom = 4
	return s


func _style_button(btn: Button) -> void:
	btn.add_theme_font_override("font", FONT)
	btn.add_theme_font_size_override("font_size", 13)
	btn.add_theme_stylebox_override("normal", _btn_box(COL_BTN, COL_PURPLE))
	btn.add_theme_stylebox_override("hover", _btn_box(COL_BTN_HOV, COL_PURPLE))
	btn.add_theme_stylebox_override("pressed", _btn_box(COL_PURPLE, COL_PURPLE))
	btn.add_theme_stylebox_override("disabled", _btn_box(Color("221b30"), COL_MUTED))
	btn.add_theme_color_override("font_color", COL_INK)
	btn.add_theme_color_override("font_hover_color", Color.WHITE)
	btn.add_theme_color_override("font_pressed_color", COL_PANEL)
	btn.add_theme_color_override("font_disabled_color", COL_MUTED)
