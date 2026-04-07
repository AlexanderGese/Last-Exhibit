class_name MuseumsSaveFile
extends SaveFile

@export var number: int = 0
@export var current_night: int = 1
@export var daily_money: int = 0
@export var artifacts: Array
@export var reputation: int = 0







func save(slot: int) -> void:
	DirAccess.make_dir_absolute(SAVE_DIR)
	ResourceSaver.save(self, SAVE_DIR + "slot_%d_MuseumsSaveFile" % slot + EXT)
