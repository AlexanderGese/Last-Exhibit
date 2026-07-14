extends RigidBody2D

@export var fire_scene : PackedScene
var ziel : Vector2
var _burst := false


func setup(start: Vector2, target: Vector2) -> void:
	global_position = start
	ziel = target
	var diff  = target - start
	var time  = 1.0
	var grav  = ProjectSettings.get_setting("physics/2d/default_gravity")
	var vx    = diff.x / time
	var vy    = (diff.y - 0.5 * grav * time * time) / time
	linear_velocity = Vector2(vx, vy)
	_arm()


func _arm() -> void:
	await get_tree().create_timer(1.05).timeout
	if is_instance_valid(self):
		burst()


func _on_body_entered(body: Node) -> void:
	burst()


func burst() -> void:
	if _burst:
		return
	_burst = true
	if fire_scene:
		var fire = fire_scene.instantiate()
		get_parent().add_child(fire)
		fire.global_position = global_position
	queue_free()
