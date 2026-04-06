extends Area2D

@export var item_data: ItemData
var can_pickup: bool = true

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func disable_pickup_temporarily(duration: float = 5.0) -> void:
	can_pickup = false
	monitoring = false
	await get_tree().create_timer(duration).timeout
	can_pickup = true
	monitoring = true

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") and can_pickup:
		if Inventory.add(item_data):
			get_tree().get_first_node_in_group("inventory_ui").refresh()
			queue_free()
		else:
			print("Inventar voll")
