class_name PlayerSaveFile
extends SaveFile

# -- Time ------------------
@export var game_minutes: int = 1320

# -- Player-Stats -----------------------
@export var hp: float = 100.0
@export var max_hp: float = 100.0
@export var money: int = 100
@export var time_shards: int = 0
# -- Epochen ------------------------------
@export var unlocked_epochs: Array[String] = ["sowjet","ww2"]

# -- Inventory ---------------
@export var equipped: Dictionary = {}



func save(slot: int) -> void:
	DirAccess.make_dir_absolute(SAVE_DIR)
	ResourceSaver.save(self, SAVE_DIR + "slot_%d_PlayerSaveFile" % slot + EXT)

func unlock(epoch: String) -> bool:
	unlocked_epochs.append(epoch)
	print("Unlocked: ")
	print(epoch)
	return true
