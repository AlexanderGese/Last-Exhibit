extends CanvasLayer

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
	SaveManager.save_all()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()


func _on_continue_pressed() -> void:
	await get_tree().create_timer(0.6).timeout
	hide_menu()

func _on_settings_pressed() -> void:
	await get_tree().create_timer(0.7).timeout
	get_tree().change_scene_to_file("res://scenes/Settings/Settings.tscn")
