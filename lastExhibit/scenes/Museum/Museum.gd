extends Node2D

func _ready() -> void:
	pass
func _physics_process(delta: float) -> void:
	SaveManager.museum.number = 15
	SaveManager.save_all(0)
