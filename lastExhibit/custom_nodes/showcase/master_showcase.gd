extends Node2D

@onready var big_item: Sprite2D = $BigShowcase/Item
@onready var small_item: Sprite2D = $SmallShowcase/Item
@onready var big_showcase: Node2D = $BigShowcase
@onready var small_showcase: Node2D = $SmallShowcase

@export var number: int

var player_is_detected: bool = false
var data: Showcase = null


func _ready() -> void:
	Events.used_artifact.connect(placeshowcase)
	_load_or_create_data()
	_refresh_visuals()


func _load_or_create_data() -> void:
	var idx = number - 1
	if idx < 0 or idx >= SaveManager.museum.showcases.size():
		push_error("Showcase index %d out of range" % idx)
		return
	
	if SaveManager.museum.showcases[idx] == null:
		var new_data = Showcase.new()
		new_data.is_empty = true
		SaveManager.museum.showcases[idx] = new_data
	
	data = SaveManager.museum.showcases[idx]


func _refresh_visuals() -> void:
	big_showcase.visible = false
	small_showcase.visible = false
	
	if data == null or data.is_empty:
		return
	
	if data.big_artifact:
		big_showcase.visible = true
		big_item.texture = data.icon
	else:
		small_showcase.visible = true
		small_item.texture = data.icon


func placeshowcase(item: Item) -> void:
	if not player_is_detected:
		return
	if data == null or not data.is_empty:
		return
	
	data.is_empty = false
	data.icon = item.icon
	data.value = item.value
	data.big_artifact = item.big_artifact
	
	_refresh_visuals()
	SaveManager.save_all(0)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_is_detected = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_is_detected = false
