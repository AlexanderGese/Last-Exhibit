extends Area2D

@export var shard_id: String = ""
@export var amount := 1

var in_area := false


func _ready() -> void:
	if shard_id != "" and SaveManager.is_shard_collected(shard_id):
		queue_free()


func _process(_delta: float) -> void:
	if in_area and Input.is_action_just_pressed("interact"):
		_collect()


func _collect() -> void:
	in_area = false
	if shard_id != "":
		SaveManager.collect_shard(shard_id, amount)
	else:
		SaveManager.player.time_shards += amount
		SaveManager.save_all()
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_area = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_area = false
