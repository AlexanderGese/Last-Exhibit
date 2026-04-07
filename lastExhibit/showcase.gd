extends Node

var is_empty = false

func _ready() -> void:
	is_empty = false
	pass 


func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if !is_empty:
			
		
