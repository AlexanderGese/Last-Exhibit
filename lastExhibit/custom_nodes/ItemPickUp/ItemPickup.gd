extends Area2D

@export var item_data: ItemData

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if Inventory.add(item_data):
			get_tree().get_first_node_in_group("inventory_ui").refresh()
			queue_free()
		else:
			print("Inventar voll")
