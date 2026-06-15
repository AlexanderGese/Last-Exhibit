extends Node2D

var in_main:bool = false
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_main and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://scenes/Museum/Museum.tscn")
		pass
	


func _on_main_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		sprite_2d.play("open")
		in_main = true


func _on_main_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		sprite_2d.play("close")
		in_main = false
