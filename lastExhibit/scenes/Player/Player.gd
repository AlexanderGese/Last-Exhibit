extends CharacterBody2D

@onready var PlayerSprite: AnimatedSprite2D = $AnimatedSprite2D

var RunSpeed = 350
var JumpSpeed = -1000
var Gravity = 2500


func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('right')
	var left = Input.is_action_pressed('left')
	var jump = Input.is_action_just_pressed('jump')
	var interact = Input.is_action_just_pressed("interact")
	var attack = Input.is_action_just_pressed("left_click")

	if is_on_floor() and jump:
		PlayerSprite.play("jump")
		velocity.y = JumpSpeed
		print("Jump")
	elif right:
		PlayerSprite.play("walking")
		velocity.x += RunSpeed
		PlayerSprite.flip_h = false
		print("Right")
	elif left:
		PlayerSprite.play("walking")
		velocity.x -= RunSpeed
		PlayerSprite.flip_h = true
		print("Left")
	else:
		PlayerSprite.play("idle")

func _physics_process(delta):
	velocity.y += Gravity * delta
	get_input()
	move_and_slide()
