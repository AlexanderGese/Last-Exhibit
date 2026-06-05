class_name ItemPickup
extends Area2D

@export var item: Item

var player_nearby: bool = false
var can_pickup: bool = true

@onready var sprite: Sprite2D = $Sprite2D
@onready var info: Sprite2D = $Info
@onready var beschreibung: Label = $Info/Beschreibung
@onready var beschreibungstext: String = item.beschreibung
@onready var artefakt : Label = $Info/Label2

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	info.visible = false
	if item:
		sprite.texture = item.icon
		artefakt.text = item.name
		artefakt.position.x += 23


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_nearby = true
		info.visible = true
		beschreibung.text = beschreibungstext


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_nearby = false
		info.visible = false


func _process(_delta: float) -> void:
	if player_nearby and can_pickup and Input.is_action_just_pressed("interact") and self.visible == true:
		if SaveManager.try_pickup(item):
			queue_free()


func disable_pickup_temporarily(duration: float = 0.5) -> void:
	can_pickup = false
	await get_tree().create_timer(duration).timeout
	can_pickup = true
