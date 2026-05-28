extends Area2D

@export var damage_per_tick : float = 3.0
@export var tick_rate       : float = 0.5
@export var duration        : float = 5.0

func _ready() -> void:
	# Lebens-Timer
	$Timer.wait_time = duration
	$Timer.start()
	
	# Schaden-Timer
	$DamageTick.wait_time = tick_rate
	$DamageTick.one_shot  = false
	$DamageTick.start()

func _on_timer_timeout() -> void:
	queue_free()

func _on_damage_tick_timeout() -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			body.take_damage(damage_per_tick)
			
