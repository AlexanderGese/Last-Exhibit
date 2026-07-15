extends Node2D

@export var speed: float = 350.0
@export var damage: float = 20.0
@export var knockback_force: float = 800.0

var direction: Vector2 = Vector2.DOWN.rotated(deg_to_rad(-10.0))
var explodiert: bool = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var treff_zone = $TreffZone


func _ready() -> void:
	treff_zone.body_entered.connect(_on_body_entered)
	treff_zone.area_entered.connect(_on_area_entered)
	animated_sprite.animation_finished.connect(_on_animation_finished)
	animated_sprite.play("default")


func _process(delta: float) -> void:
	if not explodiert:
		global_position += direction * speed * delta


func _on_body_entered(body: Node) -> void:
	if explodiert:
		return

	if body.is_in_group("player"):
		explodiere()


func _on_area_entered(area: Area2D) -> void:
	if not explodiert and (area.is_in_group("boden_zone") or area.is_in_group("turm_zone")):
		explodiere()


func explodiere() -> void:
	explodiert = true
	animated_sprite.play("explosion")

	var bodies = treff_zone.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			var player_hurtbox = body.get_node_or_null("Hurtbox")
			var kb_dir = (body.global_position - global_position).normalized()
			var kb_vector = kb_dir * knockback_force

			if player_hurtbox and player_hurtbox.has_signal("hurt"):
				player_hurtbox.hurt.emit(damage, kb_vector)
			elif body.has_method("take_damage"):
				body.take_damage(damage)


func _on_animation_finished() -> void:
	if animated_sprite.animation == "explosion":
		queue_free()
