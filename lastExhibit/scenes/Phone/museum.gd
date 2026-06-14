extends TextureRect

@onready var visitor_label: Label = $Gui/Dailyvisitors/visitors
@onready var reputation_label: Label = $Gui/Reputation/reputation
@onready var price_label: Label = $Gui/TicketPrice/price
@onready var money_label: Label = $Gui/Dailymoney/money


func _ready() -> void:
	GameClock.day_started.connect(_refresh)
	GameClock.night_started.connect(_refresh)
	Events.artifact_place.connect(_refresh.unbind(1))
	Events.used_artifact.connect(_refresh.unbind(2))
	_refresh()


func _refresh() -> void:
	if SaveManager.museum == null:
		return
	
	visitor_label.text = "%d" % SaveManager.museum.get_daily_visitors()
	price_label.text = "%d€" % SaveManager.museum.get_ticket_price()
	money_label.text = "%d€" % SaveManager.museum.calculate_daily_income()
	reputation_label.text = "%d" % SaveManager.museum.reputation
