extends Node2D

func _ready() -> void:
	GameClock.day_started.connect(_on_day_started)
	GameClock.night_started.connect(_on_night_started)
	
	if GameClock.is_night:
		AudioManager.play("museum_night")
	else:
		AudioManager.play("museum_day")

func _on_day_started() -> void:
	AudioManager.play("museum_day")


func _on_night_started() -> void:
	AudioManager.play("museum_night")
