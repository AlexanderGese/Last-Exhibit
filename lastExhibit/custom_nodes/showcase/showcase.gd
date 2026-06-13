extends Node2D


@export var number:int
var detected_player:bool = false
@export var artifact:Showcase


func _ready() -> void:
	if SaveManager.museum.showcases[number-1] != null:
		artifact = SaveManager.museum.showcases[number-1]
		
	pass

func _process(delta: float) -> void:
	Events.standing_in_showcase.emit(number)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body is CharacterBody2D:
		detected_player = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and body is CharacterBody2D:
		detected_player = false
		
