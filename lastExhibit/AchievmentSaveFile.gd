extends SaveFile
class_name AchievmentSaveFile

@export var tutorial: bool = false


func save(slot: int) -> void:
	DirAccess.make_dir_absolute(SAVE_DIR)
	ResourceSaver.save(self, SAVE_DIR + "slot_%d_AchievmentSaveFile" % slot + EXT)
