extends CharacterBody2D

@onready var PlayerSprite: AnimatedSprite2D = $AnimatedSprite2D
const RUN_SPEED = 350
const JUMP_FORCE = -750
const GRAVITY = 2500
const JUMP_CUT_GRAVITY = 6000 
const MAX_JUMP_TIME = 0.2       
const FALL_GRAVITY_MULT = 1.4   
@onready var ESCAPEMENU = preload("res://scenes/EscapeMenu/EscapeMenu.tscn")
var ESCAPEMENUINSTANCE
var save: PlayerSaveFile
@export var inv: Inv
var is_jumping := false
var jump_timer := 0.0

func _ready():
	ESCAPEMENUINSTANCE = ESCAPEMENU.instantiate()
	add_child(ESCAPEMENUINSTANCE)
	save = SaveFile.load_slot(0) as PlayerSaveFile
	if save == null:
		save = PlayerSaveFile.new()
	$Timer.start()

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_handle_movement()
	_handle_jump(delta)
	_update_animation()
	move_and_slide()
	escape_menu()
	
func escape_menu() -> void:
	if(Input.is_action_just_pressed("escape")):
		if get_tree().paused:
			ESCAPEMENUINSTANCE.hide_menu()
		else:
			ESCAPEMENUINSTANCE.show_menu()

func _apply_gravity(delta: float) -> void:
	if is_on_floor():
		return
	var grav := GRAVITY
	if velocity.y > 0:
		grav *= FALL_GRAVITY_MULT
	if is_jumping and not Input.is_action_pressed("jump"):
		grav = JUMP_CUT_GRAVITY
		is_jumping = false
	velocity.y += grav * delta

func _handle_movement() -> void:
	var direction := Input.get_axis("left", "right")
	velocity.x = direction * RUN_SPEED
	if direction != 0:
		PlayerSprite.flip_h = direction < 0

func _handle_jump(delta: float) -> void:
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_FORCE
		is_jumping = true
		jump_timer = 0.0

	if is_jumping:
		jump_timer += delta
		if jump_timer >= MAX_JUMP_TIME:
			is_jumping = false 

func _update_animation() -> void:
	if not is_on_floor():
			PlayerSprite.play("jump")
	elif velocity.x != 0:
		PlayerSprite.play("run")
	else:
		PlayerSprite.play("idle")

func take_damage(damage: float) -> void:
	save.hp = save.hp - damage
	save.save(0)

func _on_timer_timeout() -> void:
	save.save(0)

func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
