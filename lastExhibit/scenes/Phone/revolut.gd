extends TextureRect


@onready var _1: Label = $"gui/Grey/VBoxContainer/1"
@onready var _2: Label = $"gui/Grey/VBoxContainer/2"
@onready var _3: Label = $"gui/Grey/VBoxContainer/3"
@onready var _4: Label = $"gui/Grey/VBoxContainer/4"
@onready var _5: Label = $"gui/Grey/VBoxContainer/5"

@onready var timeshards: Label = $gui/HBoxContainer/timeshards/timeshards
@onready var bitcoin: Label = $gui/HBoxContainer/bitcoin/bitcoin
@onready var coins: Label = $gui/HBoxContainer/coins/coins

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	coins.text = str(SaveManager.player.money)
	timeshards.text = str(SaveManager.player.time_shards)
	bitcoin.text = str(SaveManager.player.btc)
	var past_transactions = SaveManager.player.past_five_transactions
	_1.text = past_transactions[4]
	_2.text = past_transactions[3]
	_3.text = past_transactions[2]
	_4.text = past_transactions[1]
	_5.text = past_transactions[0]
