extends Control

#HIER PFAD AUSTAUSCHEN
const NEXT_SCENE_PATH = "res://scenes/GUI/Intro2.tscn"

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "intro_start":
		get_tree().change_scene_to_file(NEXT_SCENE_PATH)
