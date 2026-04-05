extends Node

var player: PlayerSaveFile
var museum: MuseumsSaveFile

func _ready() -> void:
	load_all(0)

func save_all(slot: int) -> void:
	player.save(slot)
	museum.save(slot)

func load_all(slot: int) -> void:
	player = SaveFile.load_slot(slot) as PlayerSaveFile
	if player == null:
		player = PlayerSaveFile.new()

	museum = SaveFile.load_slot(slot) as MuseumsSaveFile
	if museum == null:
		museum = MuseumsSaveFile.new()
