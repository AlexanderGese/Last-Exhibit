extends Node2D

func _ready() -> void:
	print(SaveManager.museum.number)

func _physics_process(delta: float) -> void:
	SaveManager.museum.number = 15
	SaveManager.save_all(0)
