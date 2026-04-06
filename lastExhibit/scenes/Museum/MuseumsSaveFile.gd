class_name MuseumsSaveFile
extends SaveFile

@export var number: int = 0
@export var current_night: int = 1


func save(slot: int) -> void:
	DirAccess.make_dir_absolute(SAVE_DIR)
	ResourceSaver.save(self, SAVE_DIR + "slot_%d_MuseumsSaveFile" % slot + EXT)
