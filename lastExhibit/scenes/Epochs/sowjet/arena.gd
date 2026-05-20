extends Area2D

@export var tuer1 : Node2D
@export var tuer2 : Node2D

func _ready() -> void:
	tuer1 = get_node("/root/SovietUnion/Tuer1")
	tuer2 = get_node("/root/SovietUnion/Tuer2")
	
	print("tuer1: ", tuer1)
	print("tuer2: ", tuer2)

func _on_body_entered(body: Node) -> void:
	print("drinnen")
	if body.is_in_group("player"):
		tuer1.close()
		tuer2.close()
