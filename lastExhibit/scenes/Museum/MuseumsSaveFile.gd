class_name MuseumsSaveFile
extends SaveFile

@export var number: int = 0
@export var current_night: int = 1
@export var total_money_earned: int = 0
@export var artifacts: Array = []
@export var reputation: int = 0
@export var ground_used: bool = false
@export var first_used: bool = true
@export var second_used: bool = true
@export var showcases: Array[Showcase] = []
@export var showroom: Array[String] = []

const BASE_VISITORS: int = 10
const BASE_TICKET_PRICE: int = 5


func get_daily_visitors() -> int:
	var level = SaveManager.player.level if SaveManager.player else 1
	return BASE_VISITORS + (reputation * level)


func get_ticket_price() -> int:
	var artifact_bonus = _calculate_artifact_value() / 100
	return BASE_TICKET_PRICE + artifact_bonus


func _calculate_artifact_value() -> int:
	var total = 0
	for s in showcases:
		if s != null and not s.is_empty:
			total += s.value * s.qty
	return total


func calculate_daily_income() -> int:
	return get_daily_visitors() * get_ticket_price()


func collect_daily_income() -> int:
	var income = calculate_daily_income()
	total_money_earned += income
	if SaveManager.player:
		SaveManager.player.money += income
	return income


func save(slot: int) -> void:
	DirAccess.make_dir_absolute(SAVE_DIR)
	ResourceSaver.save(self, SAVE_DIR + "slot_%d_MuseumsSaveFile" % slot + EXT)
