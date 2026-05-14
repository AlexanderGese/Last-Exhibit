extends Area2D

@export var bounce_force: int
var player_ref: CharacterBody2D = null
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass




func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_ref = body
		player_ref.velocity.y = bounce_force
