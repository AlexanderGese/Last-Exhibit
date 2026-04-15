class_name GameSlot
extends NinePatchRect

@export var slot_type: String = "inventory"
@export var show_price: bool = false
@export var show_name: bool = false
@export var equip_type: String = ""

@onready var icon = $Icon
@onready var price_label = $PriceLabel
@onready var name_label = $NameLabel

var item: ItemData = null

func _ready() -> void:
	price_label.visible = show_price
	name_label.visible = show_name

func set_item(data: ItemData) -> void:
	item = data
	if data:
		icon.texture = data.icon
		icon.visible = true
		if show_price:
			price_label.text = str(data.black_market_value)
		if show_name:
			name_label.text = data.display_name
	else:
		icon.texture = null
		icon.visible = false
		price_label.text = ""
		name_label.text = ""

func clear() -> void:
	set_item(null)
