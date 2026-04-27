extends Control

@onready var playbutton = $Play/AnimatedSprite2D
@onready var settingsbutton = $Settings/AnimatedSprite2D
@onready var quitbutton = $Quit/AnimatedSprite2D

func _ready() ->void:
	AudioManager.play("trailer")


# Play
func _on_play_pressed() -> void:
	playbutton.play("click")
	await get_tree().create_timer(0.35).timeout
	get_tree().change_scene_to_file("res://scenes/Museum/Museum.tscn")
	

# Settings
func _on_settings_pressed() -> void:
	settingsbutton.play("default")
	await get_tree().create_timer(0.65).timeout
	get_tree().change_scene_to_file("res://scenes/Settings/Settings.tscn")

#Quit
func _on_quit_pressed() -> void:
	quitbutton.play("default")
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
