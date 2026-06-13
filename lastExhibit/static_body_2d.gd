extends StaticBody2D

@export var max_hp: int = 100
@export var auto_reset_after_death: bool = true
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hurtbox_collision: CollisionShape2D = $Hurtbox/CollisionShape2D
@onready var hp_label: Label = $HPLabel
@onready var reset_timer: Timer = $ResetTimer

var current_hp: int
var total_damage_taken: int = 0
var hit_count: int = 0
var is_dead: bool = false

func _ready() -> void:
	current_hp = max_hp
	hurtbox.hurt.connect(_on_hurt)
	reset_timer.timeout.connect(_reset)
	_update_label()

func _on_hurt(damage: int, knockback: Vector2) -> void:
	sprite_2d.play("onhit")
	if is_dead:
		return
	
	current_hp -= damage
	total_damage_taken += damage
	hit_count += 1
	_spawn_damage_number(damage)
	
	print("Dummy hit! -", damage, " HP | knockback: ", knockback)
	

	_update_label()
	
	if current_hp <= 0:
		_die()
	sprite_2d.play("default")

func _update_label() -> void:
	if is_dead:
		hp_label.text = "💀\nResetting..."
	else:
		hp_label.text = "HP: %d / %d\nHits: %d\nDamage: %d" % [current_hp, max_hp, hit_count, total_damage_taken]

func _die() -> void:
	is_dead = true
	hurtbox_collision.disabled = true
	print("Dummy gestorben — Stats: ", hit_count, " Hits, ", total_damage_taken, " Damage")
	_update_label()
	
	if auto_reset_after_death:
		reset_timer.start()

func _reset() -> void:
	current_hp = max_hp
	total_damage_taken = 0
	hit_count = 0
	is_dead = false
	hurtbox_collision.disabled = false
	_update_label()
	print("Dummy reset")

func _spawn_damage_number(damage: int) -> void:
	var label = Label.new()
	label.text = str(damage)
	label.add_theme_font_size_override("font_size", 32)
	label.add_theme_color_override("font_color", Color(1, 0.3, 0.3))
	label.position = Vector2(randf_range(-20, 20), -40)
	add_child(label)
	
	var tween = create_tween().set_parallel()
	tween.tween_property(label, "position:y", label.position.y - 50, 0.8)
	tween.tween_property(label, "modulate:a", 0.0, 0.8)
	tween.chain().tween_callback(label.queue_free)
