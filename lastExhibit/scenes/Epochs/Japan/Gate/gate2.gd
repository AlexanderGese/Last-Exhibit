extends AnimatedSprite2D

var is_open : bool = false



func open() -> void:
	if is_open :
		return
	is_open = true
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
	play("opening")
	await animation_finished
	play("open")
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
	


func close() -> void:
	if not is_open:
		return
	is_open = false
	
	play("closing")
	await animation_finished
	play("closed")
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
