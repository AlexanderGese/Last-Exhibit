class_name SaveFile
extends Resource

const SAVE_DIR := "user://saves/"
const EXT := ".tres"  # zu .res ändern vor Release

# Nutzung : 
# Erstelle ein Locales gd script mit dem namen des levels oder was man saven möchte ("MueseumsSaveFile.gd")
# in das schreibt man dann :
# class_name MuseumsSaveFile
# extends SaveFile
#
# @export var ("namen der variable die zu speichern ist"): typ der variable ("z.B. String") = leere variable ("z.B. "" ")
# ....
# 
#
# in dem jeweiligen file wie zum beispiel Museum.gd benutzt man es dann so:
# var save := MuseumSaveFile.new()
# func _ready() -> void:
#    save = SaveFile.load_slot(0) as MuseumSaveFile
#    if save == null:
#        save = MuseumSaveFile.new()
# save.("Name der variable in MuseumsSaveFile") = ....
# save.save(0) "speichert es dann die 0 ist der spiel stand beleibt aber bei 0"


# Jeden Spielstand mit Slot-Nummer speichern
func save(slot: int) -> void:
	DirAccess.make_dir_absolute(SAVE_DIR)
	var path = SAVE_DIR + "slot_%d_%s" % [slot, resource_path.get_file().get_basename()] + EXT
	ResourceSaver.save(self, path)

func _path(slot: int) -> String:
	return SAVE_DIR + "slot_%d_%s" % [slot, get_class()] + EXT

static func load_slot(slot: int, type: String) -> SaveFile:
	var path := SAVE_DIR + "slot_%d_%s" % [slot, type] + EXT
	if not FileAccess.file_exists(path):
		return null
	return ResourceLoader.load(path) as SaveFile
static func slot_exists(slot: int) -> bool:
	return FileAccess.file_exists(SAVE_DIR + "slot_%d" % slot + EXT)

static func delete_slot(slot: int) -> void:
	DirAccess.open(SAVE_DIR).remove("slot_%d" % slot + EXT)
