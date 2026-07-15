class_name PlayerSaveFile
extends SaveFile

# -- Time ------------------
@export var game_minutes: int = 1320

# -- Player-Stats -----------------------
@export var hp: float = 1000.0
@export var max_hp: float = 100.0
@export var money: int = 0
@export var time_shards: int = 0
@export var btc: int = 0
@export var level: int = 1
# -- Epochen ------------------------------
@export var unlocked_epochs: Array[String] = ["sowjet"]
@export var tor_app: bool = false
@export var museum_app: bool = false
@export var flappy_app: bool = false
@export var level_time = 60
# -- Inventory ---------------
@export var equipped: Dictionary = {}
@export var messages: Array[String] = ["/", "/", "/", "/", "/", "/", "/", "/", "/"]

# -- DAta -------
@export var past_five_transactions: Array[String] = ["/", "/", "/", "/", "/"]
@export var playertiner: int = 0
@export var seen_tutorials: Array[String] = []
@export var collected_shards: Array[String] = []
@export var collected_pickups: Array[String] = []
@export var combo_bonus: int = 0
@export var finished_game: bool = false


func _init() -> void:
	hp = 1000.0
	max_hp = 100.0
	money = 0
	time_shards = 0
	btc = 0
	level = 1
	level_time = 60
	unlocked_epochs = ["sowjet"]
	tor_app = false
	museum_app = false
	flappy_app = false
	equipped = {}
	messages = ["/", "/", "/", "/", "/", "/", "/", "/", "/"]
	past_five_transactions = ["/", "/", "/", "/", "/"]
	seen_tutorials = []
	collected_shards = []
	collected_pickups = []
	combo_bonus = 0


func add_transcation(item: String, price: int, currency: String) -> void:
	var item_label: String = item + " " + str(price) + " " + currency
	past_five_transactions.push_back(item_label)
	if past_five_transactions.size() > 5:
		past_five_transactions.pop_front()


func add_message(text: String) -> void:
	messages.push_back(text)
	if messages.size() > 9:
		messages.pop_front()


func clear_messages():
	for i in range(8):
		add_message("")


func buy(price: int, item: String, currency: String) -> bool:
	if currency == "coins":
		if money >= price:
			money -= price
			add_transcation(item, price, currency)
			return true
	elif currency == "time_shards":
		if time_shards >= price:
			time_shards -= price
			add_transcation(item, price, currency)
			return true
	elif currency == "btc":
		if btc >= price:
			btc -= price
			add_transcation(item, price, currency)
			return true
	return false


func save(slot: int) -> void:
	DirAccess.make_dir_absolute(SAVE_DIR)
	ResourceSaver.save(self, SAVE_DIR + "slot_%d_PlayerSaveFile" % slot + EXT)


func unlock(epoch: String) -> bool:
	unlocked_epochs.append(epoch)
	print("Unlocked: ")
	print(epoch)
	return true
