extends CharacterBody2D
 


@export var move_speed : float = 180.0
@export var sprint_speed : float = 400.0
@export var gravity : float =  980
@export var tuer1 : AnimatedSprite2D
@export var tuer2 : AnimatedSprite2D
@export var tuer3 : AnimatedSprite2D
var player : CharacterBody2D
var is_cornered : bool = false
var right : bool = true
var is_sprinting : bool = false
var sprint_ziel_x : float = 0.0
var player_collided : bool = false
enum State { WALK, SPRINT }
var state : State = State.WALK

func _ready() -> void:
	await get_tree().process_frame
	
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
	
	$AnimatedSprite2D.flip_h = velocity.x < 0
	
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

func _dist() -> float:
	if player == null:
		return 9999.0
	return global_position.distance_to(player.global_position)

func _distx() -> float:
	if player == null:
		return 9999.0
	return abs(global_position.x - player.global_position.x)
