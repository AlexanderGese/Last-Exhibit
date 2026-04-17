extends Node

var player: PlayerSaveFile
var museum: MuseumsSaveFile
var achievements: AchievmentSaveFile


func _ready() -> void:
	load_all(0)

func save_all(slot: int) -> void:
	player.save(slot)
	museum.save(slot)

func load_all(slot: int) -> void:
	player = SaveFile.load_slot(slot, "PlayerSaveFile") as PlayerSaveFile
	if player == null:
		player = PlayerSaveFile.new()
	museum = SaveFile.load_slot(slot, "MuseumsSaveFile") as MuseumsSaveFile
	if museum == null:
		museum = MuseumsSaveFile.new()
