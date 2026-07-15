extends Control


func _ready() -> void:
	AudioManager.play("trailer")


func _on_play_pressed() -> void:
	$SaveSelect.open()


func _on_quit_pressed() -> void:
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
