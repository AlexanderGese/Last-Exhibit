extends CharacterBody2D
 
@export var flasche_scene : PackedScene
@export var bullet_scene : PackedScene
@export var granate_scene : PackedScene
@export var atem_scene : PackedScene
@export var move_speed : float = 180.0
@export var sprint_speed : float = 400.0
@export var max_hp : int = 300
@export var attack_cooldown : float = 3.0
@export var knockback_resistance : float = 0.7   

@export var tuer1 : AnimatedSprite2D
@export var tuer2 : AnimatedSprite2D
@export var tuer3 : AnimatedSprite2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Hurtbox = $Hurtbox

const ORIGINAL_MODULATE := Color.WHITE
const FLASH_COLOR := Color(2.5, 0.3, 0.3, 1)

var attack_timer : float = 0.0
var player : CharacterBody2D
var is_cornered : bool = false
var is_sprinting : bool = false
var sprint_ziel_x : float = 0.0
var player_collided : bool = false

enum State { WALK, SPRINT, SPRINT2 }
var state : State = State.WALK
var facing_right : bool = true
var old_facing_right : bool = true
var hp : int 
var current_atem : Node = null
var is_attacking : bool = false
var is_dead : bool = false
var flash_tween: Tween = null


func _ready() -> void:
	await get_tree().process_frame
	hp = max_hp
	tuer1 = get_node("/root/SovietUnion/Tuer1")
	tuer2 = get_node("/root/SovietUnion/Tuer2")
	tuer3 = get_node("/root/SovietUnion/Tuer3")
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	
	hurtbox.hurt.connect(_on_hurt)
	sprite.play("idle")


func _physics_process(delta: float) -> void:
	if player == null or is_dead:
		return
	
	attack_timer -= delta
	
	if state == State.WALK:
		if attack_timer <= 0.0 and not is_attacking:
			_pick_attack()
			attack_timer = attack_cooldown
		
		velocity.x = move_toward(velocity.x, 0.0, 20.0)
		var dist = _distx()
		var dir = sign(player.global_position.x - global_position.x)
		
		var too_close = _distx() < 100.0
		if too_close and state != State.SPRINT:
			state = State.SPRINT
		elif dist > 350.0:
			velocity.x = dir * move_speed
		elif dist < 250.0:
			velocity.x = -dir * move_speed
		else:
			velocity.x = 0.0
		
		velocity.x = 0.0 if global_position.x <= -690.0 and velocity.x < 0.0 else velocity.x
		velocity.x = 0.0 if global_position.x >= 245.0 and velocity.x > 0.0 else velocity.x
	
	if state == State.SPRINT:
		var richtung_ziel = sign(sprint_ziel_x - global_position.x)
		velocity.x = richtung_ziel * sprint_speed
		if abs(global_position.x - sprint_ziel_x) < 10.0:
			state = State.WALK
	
	if state == State.SPRINT2:
		var richtung_ziel = sign(sprint_ziel_x - global_position.x)
		velocity.x = richtung_ziel * sprint_speed
		
		if current_atem == null:
			current_atem = atem_scene.instantiate()
			add_child(current_atem)
			current_atem.position = Vector2(8.0 if facing_right else -8.0, -25)
			current_atem.start(facing_right)
		
		if abs(global_position.x - sprint_ziel_x) < 10.0:
			if is_instance_valid(current_atem):
				current_atem.ende()
			current_atem = null
			state = State.WALK
		
	move_and_slide()
	
	if velocity.x > 5:
		facing_right = true
	elif velocity.x < -5:
		facing_right = false
	elif abs(velocity.x) < 1.0:
		facing_right = player.global_position.x > global_position.x
	sprite.flip_h = not facing_right
	
	_update_animation()


func _update_animation() -> void:
	if is_attacking or is_dead:
		return
	
	if state == State.SPRINT or state == State.SPRINT2:
		if sprite.animation != "walk":
			sprite.play("walk")
		sprite.speed_scale = 1.6
	elif abs(velocity.x) > 5:
		if sprite.animation != "walk":
			sprite.play("walk")
		sprite.speed_scale = 1.0
	else:
		if sprite.animation != "idle":
			sprite.play("idle")
		sprite.speed_scale = 1.0


func _on_hurt(damage: int, knockback: Vector2) -> void:
	if is_dead:
		return
	
	hp -= damage
	velocity += knockback * (1.0 - knockback_resistance)
	
	_play_hurt_flash()
	
	if hp <= 0:
		_die()


func _play_hurt_flash() -> void:
	if flash_tween and flash_tween.is_valid():
		flash_tween.kill()
	
	sprite.modulate = FLASH_COLOR
	flash_tween = create_tween()
	flash_tween.tween_interval(0.1)
	flash_tween.tween_property(sprite, "modulate", ORIGINAL_MODULATE, 0.2)


func _die() -> void:
	is_dead = true
	is_attacking = false
	hurtbox.queue_free()
	if is_instance_valid(current_atem):
		current_atem.queue_free()
	
	if flash_tween and flash_tween.is_valid():
		flash_tween.kill()
	sprite.modulate = ORIGINAL_MODULATE
	
	velocity = Vector2.ZERO
	sprite.speed_scale = 1.0
	sprite.play("dead")
	await sprite.animation_finished
	
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 0.8)
	tween.tween_callback(queue_free)


func _dist() -> float:
	if player == null:
		return 9999.0
	return global_position.distance_to(player.global_position)


func _distx() -> float:
	if player == null:
		return 9999.0
	return abs(global_position.x - player.global_position.x)


func _get_spawn(offset_x: float, offset_y: float) -> Vector2:
	return global_position + Vector2(offset_x if facing_right else -offset_x, offset_y)


func _pick_attack() -> void:
	var r = randf()
	if r < 0.30:
		atk_molotov()
	elif r < 0.75:
		atk_AK47()
	else:
		atk_granate()


func atk_molotov() -> void:
	is_attacking = true
	sprite.speed_scale = 1.0
	sprite.play("throw")
	await sprite.animation_finished
	
	if is_dead:
		is_attacking = false
		return
	
	var flasche = flasche_scene.instantiate()
	get_parent().add_child(flasche)
	flasche.setup(_get_spawn(15, -20), player.global_position)
	is_attacking = false


func atk_AK47() -> void:
	is_attacking = true
	sprite.speed_scale = 1.0
	sprite.play("shot")
	
	# 2 Bullets während der Animation
	for i in range(2):
		await get_tree().create_timer(0.15).timeout
		if is_dead:
			is_attacking = false
			return
		var bullet = bullet_scene.instantiate()
		get_parent().add_child(bullet)
		bullet.setup(_get_spawn(15, -15), Vector2(1.0 if facing_right else -1.0, 0.0))
	
	# Safety-Timeout falls animation_finished nicht feuert
	var timeout = get_tree().create_timer(0.5)
	while sprite.animation == "shot" and sprite.is_playing() and not timeout.time_left <= 0:
		await get_tree().process_frame
	
	is_attacking = false


func atk_granate() -> void:
	is_attacking = true
	sprite.speed_scale = 1.0
	sprite.play("throw")
	await sprite.animation_finished
	
	if is_dead:
		is_attacking = false
		return
	
	var granate = granate_scene.instantiate()
	get_parent().add_child(granate)
	granate.setup(_get_spawn(15, -20), player.global_position)
	is_attacking = false
