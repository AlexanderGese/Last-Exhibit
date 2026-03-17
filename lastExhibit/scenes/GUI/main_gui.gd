extends Node2D

# Play
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/play/play.tscn")

# Settings
func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/settings/settings.tscn")

#Fabian hat massiv Arschwasser
#und du liebst es das zu trinken
#im sommer gefrierst du es ein und lutschst es wie ein eis
#Quit
func _on_quit_pressed() -> void:
	get_tree().quit()
