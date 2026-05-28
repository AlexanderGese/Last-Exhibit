extends RigidBody2D

@export var fire_scene : PackedScene
var ziel : Vector2


func setup(start: Vector2, target: Vector2) -> void:
	global_position = start
	ziel = target
	var diff  = target - start
	var time  = 1.0
	var grav  = ProjectSettings.get_setting("physics/2d/default_gravity")
	var vx    = diff.x / time
	var vy    = (diff.y - 0.5 * grav * time * time) / time
	linear_velocity = Vector2(vx, vy)



func _on_body_entered(body: Node) -> void:
	if fire_scene:
		var fire = fire_scene.instantiate()
		get_parent().add_child(fire)
		fire.global_position = global_position
	queue_free()
