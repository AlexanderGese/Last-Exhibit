extends CanvasLayer

@onready var continuebutton: AnimatedSprite2D = $Control/Continue/AnimatedSprite2D
@onready var settingsbutton: AnimatedSprite2D = $Control/Settings/AnimatedSprite2D2
@onready var quitbutton: AnimatedSprite2D = $Control/Quit/AnimatedSprite2D3
@onready var texture_rect: TextureRect = $CanvasLayer/TextureRect


func _ready():
	texture_rect.visible = false
	hide()

func show_menu():
	show()
	texture_rect.visible = true
	get_tree().paused = true

func hide_menu():
	hide()
	texture_rect.visible = false
	get_tree().paused = false


func _on_quit_pressed():
	SaveManager.save_all(0)
	quitbutton.play("default")
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()


func _on_continue_pressed() -> void:
	continuebutton.play("default")
	await get_tree().create_timer(0.6).timeout
	hide_menu()
	continuebutton.frame = 0
	continuebutton.stop()


func _on_settings_pressed() -> void:
	settingsbutton.play("default")
	await get_tree().create_timer(0.7).timeout
	get_tree().change_scene_to_file("res://scenes/Settings/Settings.tscn")
