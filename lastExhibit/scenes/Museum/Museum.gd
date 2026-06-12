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
	print("=== start_day ===")
	print("daily_visitors: ", SaveManager.museum.daily_visitors)
	print("ground_used: ", ground_used, " first_used: ", first_used, " second_used: ", second_used)
	clear_visitors()
	
	var active_floors: Array[String] = []
	if ground_used: active_floors.append("spawn_ground")
	if first_used:  active_floors.append("spawn_first")
	if second_used: active_floors.append("spawn_second")
	
	print("active_floors: ", active_floors)
	
	if active_floors.is_empty():
		print("Keine aktiven Stockwerke")
		return
	
	var total = SaveManager.museum.daily_visitors
	print("Spawne total: ", total)
	for i in range(total):
		var group_name = active_floors[i % active_floors.size()]
		print("Spawne Visitor ", i, " in ", group_name)
		_spawn_visitor_in_group(group_name)

func _spawn_visitor_in_group(group_name: String) -> void:
	var spawn_points = get_tree().get_nodes_in_group(group_name)
	print("  Spawn-Points in '", group_name, "': ", spawn_points.size())
	if spawn_points.is_empty():
		push_warning("Keine Spawn-Points in Gruppe: %s" % group_name)
		return
	
	var spawn_point = spawn_points.pick_random()
	print("  Gewählter Spawn-Point: ", spawn_point, " bei ", spawn_point.global_position)
	var visitor = VISITOR_SCENE.instantiate()
	print("  Visitor instanziert: ", visitor)
	visitors_container.add_child(visitor)
	visitor.global_position = spawn_point.global_position
	print("  Visitor in Tree, position: ", visitor.global_position)
	
func start_night() -> void:
	print("Nacht beginnt, Museum schließt")
	clear_visitors()


func clear_visitors() -> void:
	for v in visitors_container.get_children():
		v.queue_free()
