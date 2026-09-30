extends Control

const GRAVITY := 1200.0
const JUMP_VELOCITY := -400.0
const PIPE_SPEED := 200.0
const PIPE_GAP := 190
const PIPE_SCENE := preload("res://scenes/Phone/pipe.tscn")

@onready var bird: Control = $Bird
@onready var pipes_container: Node2D = $Pipes
@onready var score_label: Label = $Count
@onready var game_over_label: Label = $Gameover
@onready var pipe_spawn_timer: Timer = $Pipetimer

var bird_velocity := 0.0
var score := 0
var is_playing := false
var is_dead := false


func _ready() -> void:
	game_over_label.visible = false
	pipe_spawn_timer.timeout.connect(_spawn_pipe)
	_reset_game()


func _process(delta: float) -> void:
	if not is_playing or is_dead:
		return

	# Bird physics
	bird_velocity += GRAVITY * delta
	bird.position.y += bird_velocity * delta

	bird.rotation = clamp(bird_velocity * 0.002, -0.3, 1)

	# Move pipes
	for pipe in pipes_container.get_children():
		pipe.position.x -= PIPE_SPEED * delta
		if pipe.position.x < 5:
			pipe.queue_free()

	# Check bounds (top and bottom of screen)
	if bird.position.y < 0 or bird.position.y > size.y - bird.size.y:
		_die()

	# Check pipe collisions
	for pipe in pipes_container.get_children():
		if pipe.has_method("check_collision") and pipe.check_collision(bird):
			_die()
		if pipe.has_method("check_score") and pipe.check_score(bird):
			_add_score()


func _unhandled_input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	if (
		event.is_action_pressed("ui_accept")
		or (event is InputEventKey and event.pressed and event.keycode == KEY_SPACE)
	):
		if is_dead:
			_reset_game()
		elif not is_playing:
			_start_game()
			_jump()
		else:
			_jump()


func _jump() -> void:
	bird_velocity = JUMP_VELOCITY


func _start_game() -> void:
	is_playing = true
	pipe_spawn_timer.start()
	_spawn_pipe()  # immediately spawn first one


func _die() -> void:
	is_dead = true
	is_playing = false
	score_label.visible = false
	pipe_spawn_timer.stop()
	game_over_label.text = (
		"Game Over!\nScore: %d\n[Leertaste] , for each 10 points you get 1 coin" % score
	)
	SaveManager.player.money += score / 10
	game_over_label.visible = true


func _reset_game() -> void:
	is_dead = false
	is_playing = false
	score = 0
	score_label.visible = true
	score_label.text = "0"
	bird.position = Vector2(80, size.y / 2)
	bird.rotation = 0.0
	bird_velocity = 0.0
	game_over_label.visible = false
	for pipe in pipes_container.get_children():
		pipe.queue_free()


func _add_score() -> void:
	score += 1
	score_label.text = str(score)


func _spawn_pipe() -> void:
	var pipe = PIPE_SCENE.instantiate()
	pipes_container.add_child(pipe)
	pipe.position.x = size.x - 35
	var gap_center = randf_range(80, size.y - 80)
	pipe.setup(gap_center, PIPE_GAP, size.y)
