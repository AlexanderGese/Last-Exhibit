class_name MuseumsSaveFile
extends SaveFile

@export var number: int = 0
@export var current_night: int = 1
@export var daily_money: int = 0
@export var daily_visitors: int = 10
@export var ticket_price: int = 10
@export var artifacts: Array
@export var reputation: int =  0
@export var ground_used: bool = false
@export var first_used: bool = true
@export var second_used: bool = true
@export var showcases: Array[Showcase]



func _process(delta: float) -> void:
	daily_visitors = (reputation * SaveManager.player.level) + 10
	ticket_price = reputation * len(artifacts)
	daily_money = daily_money * daily_visitors





func save(slot: int) -> void:
	DirAccess.make_dir_absolute(SAVE_DIR)
	ResourceSaver.save(self, SAVE_DIR + "slot_%d_MuseumsSaveFile" % slot + EXT)
