extends Node2D

var save : MuseumsSaveFile

func _ready() -> void:
	save = SaveFile.load_slot(0) as MuseumsSaveFile
	if (save == null):
		save = MuseumsSaveFile.new()
	print(save.number)
	
func _physics_process(delta: float) -> void:
	save.number = 15
	save.save(0)
