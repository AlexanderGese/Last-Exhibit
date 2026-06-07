extends Node2D


# Called when the node enters the scene tree for the first time.
@export var number:int
var detected_player:bool = false

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Events.standing_in_showcase.emit(number)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body is CharacterBody2D:
		detected_player = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and body is CharacterBody2D:
		detected_player = false
		
