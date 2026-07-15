class_name ItemPickup
extends Area2D

@export var item: Item
@export var once: bool = false
@export var icon_size: float = 28.0

var player_nearby: bool = false
var can_pickup: bool = true

@onready var sprite: Sprite2D = $Sprite2D
@onready var info: Sprite2D = $Info
@onready var beschreibung: Label = $Info/Label


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	info.visible = false
	if once and SaveManager.is_pickup_collected(_pickup_id()):
		visible = false
		return
	if item and item.icon:
		sprite.texture = item.icon
		_fit_icon()


func _pickup_id() -> String:
	var scene := get_tree().current_scene
	var base: String = scene.scene_file_path if scene else ""
	return base + "|" + str(get_path())


func _fit_icon() -> void:
	if sprite.texture == null:
		return
	var s: Vector2 = sprite.texture.get_size()
	if s.x <= 0.0 or s.y <= 0.0:
		return
	var f: float = icon_size / maxf(s.x, s.y)
	sprite.scale = Vector2(f, f)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_nearby = true
		if item:
			info.visible = true
			beschreibung.text = item.name


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_nearby = false
		info.visible = false


func _process(_delta: float) -> void:
	if (
		player_nearby
		and can_pickup
		and item != null
		and Input.is_action_just_pressed("interact")
		and self.visible == true
	):
		if SaveManager.try_pickup(item):
			if once:
				SaveManager.collect_pickup(_pickup_id())
			queue_free()


func disable_pickup_temporarily(duration: float = 0.5) -> void:
	can_pickup = false
	await get_tree().create_timer(duration).timeout
	can_pickup = true
