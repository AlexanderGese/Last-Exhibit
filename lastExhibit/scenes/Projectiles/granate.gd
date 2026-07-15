extends RigidBody2D
@export var explosion_scene: PackedScene
var ziel: Vector2


func setup(start: Vector2, target: Vector2) -> void:
	global_position = start
	ziel = target
	var diff = target - start
	var time = 0.5
	var grav = ProjectSettings.get_setting("physics/2d/default_gravity")
	var vx = diff.x / time
	var vy = (diff.y - 0.5 * grav * time * time) / time
	linear_velocity = Vector2(vx, vy)


func _on_body_entered(body: Node) -> void:
	#ruft die Explosions-Szene auf und löscht sich
	if explosion_scene:
		var explosion = explosion_scene.instantiate()
		get_parent().add_child(explosion)
		explosion.global_position = global_position
		explosion.explode()
	queue_free()
