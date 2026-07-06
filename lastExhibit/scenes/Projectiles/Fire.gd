extends Node2D

@export var tick_rate: float = 0.5
@export var duration: float = 5.0

@onready var hitbox: Hitbox = $Hitbox
@onready var hitbox_shape: CollisionShape2D = $Hitbox/CollisionShape2D


func _ready() -> void:
	$Timer.wait_time = duration
	$Timer.start()
	$DamageTick.wait_time = tick_rate
	$DamageTick.one_shot = false
	$DamageTick.start()
	
	hitbox_shape.disabled = true   


func _on_timer_timeout() -> void:
	queue_free()

#aktiviert die damage hitbox jeden damage tick und deaktiviert sie wieder
func _on_damage_tick_timeout() -> void:
	hitbox_shape.disabled = false
	await get_tree().create_timer(0.05).timeout
	if is_instance_valid(self):
		hitbox_shape.disabled = true
