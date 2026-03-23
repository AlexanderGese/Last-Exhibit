class_name HurtBox
extends Area2D

signal hit(damage: int, knockback: Vector2)

@export var invincibility_time := 0.0
var _invincible := false

func _init() -> void:
	collision_layer = 0
	collision_mask = 2

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(hitbox: HitBox) -> void:
	if _invincible: return
	hit.emit(hitbox.damage, hitbox.knockback)
	if invincibility_time > 0:
		_invincible = true
		await get_tree().create_timer(invincibility_time).timeout
		_invincible = false
