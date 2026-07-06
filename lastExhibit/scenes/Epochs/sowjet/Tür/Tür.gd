extends AnimatedSprite2D

var is_open : bool = false

func _ready() -> void:
	Events.sw_boss_dead.connect(open)
	
#oeffnet die tuer
func open() -> void:
	if is_open:
		return
	is_open = true
	play("opening")
	await animation_finished
	play("open")
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)

#schliesst die tuer
func close() -> void:
	if not is_open:
		return
	is_open = false
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
	play("closing")
	await animation_finished
	play("closed")
