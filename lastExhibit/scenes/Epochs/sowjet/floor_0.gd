extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	pass 



func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		get_tree().call_group("lastenaufzug", "aufzug_aktivieren", 0)



func _process(delta: float) -> void:
	pass
