extends CharacterBody2D
 

@export var flasche_scene : PackedScene
@export var bullet_scene : PackedScene
@export var move_speed : float = 180.0
@export var sprint_speed : float = 400.0
@export var max_hp : int = 300
@export var tuer1 : AnimatedSprite2D
@export var tuer2 : AnimatedSprite2D
@export var tuer3 : AnimatedSprite2D

var player : CharacterBody2D
var is_cornered : bool = false
var is_sprinting : bool = false
var sprint_ziel_x : float = 0.0
var player_collided : bool = false
enum State { WALK, SPRINT }
var state : State = State.WALK
var facing_right : bool = true
var old_facing_right : bool = true
var countdown : int=200 
var enraged : bool = false
var hp : int 

func _ready() -> void:
	await get_tree().process_frame
	hp=max_hp
	tuer1 = get_node("/root/SovietUnion/Tuer1")
	tuer2 = get_node("/root/SovietUnion/Tuer2")
	tuer3 = get_node("/root/SovietUnion/Tuer3")
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	tuer1.open()
	tuer2.open()

func _physics_process(delta: float) -> void:
	if player == null:
		return
	
	if  hp<250 and enraged== false :
		enraged =true
	
	countdown =countdown-1
	
	if countdown < 1 :
		atk_AK47()
		countdown=200
	
	if state == State.WALK:
		velocity.x = move_toward(velocity.x, 0.0, 20.0)
		var dist = _distx()
		var dir  = sign(player.global_position.x - global_position.x)
		
		var left_wall  = global_position.x <= -650.0
		var right_wall = global_position.x >= 205.0
		var too_close = _distx() < 100.0
		if too_close and (left_wall or right_wall) and state != State.SPRINT:
			state         = State.SPRINT
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
		velocity.x       = richtung_ziel * sprint_speed
		if abs(global_position.x - sprint_ziel_x) < 10.0:
			state = State.WALK
	
	move_and_slide()
	
	if velocity.x > 5:
		facing_right = true
	elif velocity.x < -5:
		facing_right = false
	elif abs(velocity.x) < 1.0:
		facing_right = player.global_position.x > global_position.x
	$AnimatedSprite2D.flip_h = not facing_right
	
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

func atk_molotov() -> void:
	var flasche = flasche_scene.instantiate()
	get_parent().add_child(flasche)
	flasche.setup(_get_spawn(15,-20), player.global_position)

func atk_AK47() -> void:
	for i in range(2):
		var bullet = bullet_scene.instantiate()
		get_parent().add_child(bullet)
		bullet.setup(_get_spawn(15,-15), Vector2(1.0 if facing_right else -1.0, 0.0))
		await get_tree().create_timer(0.15).timeout
	
