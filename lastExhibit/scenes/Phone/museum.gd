extends TextureRect


@onready var money:int
@onready var visitors:int
@onready var reputation:int
@onready var ticketprice:int  
@onready var visitor: Label = $Gui/Dailyvisitors/visitors
@onready var reputatio: Label = $Gui/Reputation/reputation
@onready var price: Label = $Gui/TicketPrice/price
@onready var monei: Label = $Gui/Dailymoney/money

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pricelogic()


func pricelogic()-> void:
	money = SaveManager.museum.daily_money
	monei.text = str(money)
	visitors = SaveManager.museum.daily_visitors
	visitor.text = str(visitors)
	reputation = SaveManager.museum.reputation
	reputatio.text = str(reputation)
	ticketprice = SaveManager.museum.ticket_price
	price.text = str(ticketprice)
