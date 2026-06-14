extends Node2D

const VISITOR_SCENE = preload("res://scenes/Museum/visitor.tscn")

@export var ground_used: bool = false
@export var first_used: bool = true
@export var second_used: bool = true

@onready var visitors_container: Node2D = $Visitors

func _ready() -> void:
	GameClock.day_started.connect(_on_day_started)
	GameClock.night_started.connect(_on_night_started)
	if GameClock.is_night:
		_on_night_started()
	else:
		_on_day_started()
	start_day()

func _on_day_started() -> void:
	AudioManager.play("museum_day")
	start_day()

func _on_night_started() -> void:
	AudioManager.play("museum_night")
	start_night()

func start_day() -> void:

	clear_visitors()
	
	var active_floors: Array[String] = []
	if ground_used: active_floors.append("spawn_ground")
	if first_used:  active_floors.append("spawn_first")
	if second_used: active_floors.append("spawn_second")
	
	
	if active_floors.is_empty():
		return
	
	var total = SaveManager.museum.get_daily_visitors()
	for i in range(total):
		var group_name = active_floors[i % active_floors.size()]
		_spawn_visitor_in_group(group_name)

func _spawn_visitor_in_group(group_name: String) -> void:
	var spawn_points = get_tree().get_nodes_in_group(group_name)
	if spawn_points.is_empty():
		return
	
	var spawn_point = spawn_points.pick_random()
	var visitor = VISITOR_SCENE.instantiate()
	visitors_container.add_child(visitor)
	visitor.global_position = spawn_point.global_position
	
func start_night() -> void:
	clear_visitors()


func clear_visitors() -> void:
	for v in visitors_container.get_children():
		v.queue_free()
