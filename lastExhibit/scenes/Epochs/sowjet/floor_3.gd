extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	pass 

#ruft den Aufzug auf sein Level
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		get_tree().call_group("lastenaufzug", "aufzug_aktivieren", 3)
