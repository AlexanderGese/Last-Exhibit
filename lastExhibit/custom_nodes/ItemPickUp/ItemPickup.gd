extends Area2D

@export var item: Item

var player_nearby: bool = false
var can_pickup: bool = true

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	if item:
		sprite.texture = item.icon


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_nearby = true


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_nearby = false


func _process(_delta: float) -> void:
	if player_nearby and can_pickup and Input.is_action_just_pressed("interact"):
		if SaveManager.try_pickup(item):
			queue_free()


func disable_pickup_temporarily(duration: float = 0.5) -> void:
	can_pickup = false
	await get_tree().create_timer(duration).timeout
	can_pickup = true
