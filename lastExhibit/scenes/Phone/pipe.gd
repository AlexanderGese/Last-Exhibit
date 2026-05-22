extends Node2D

const PIPE_WIDTH := 35

@onready var top_pipe: ColorRect = $TopPipe
@onready var bottom_pipe: ColorRect = $BottomPipe

var gap_top := 0.0
var gap_bottom := 0.0
var scored := false

func setup(gap_center: float, gap_size: float, screen_height: float) -> void:
	gap_top = gap_center - gap_size / 2
	gap_bottom = gap_center + gap_size / 2
	
	top_pipe.position = Vector2(0, 0)
	top_pipe.size = Vector2(PIPE_WIDTH, gap_top)
	top_pipe.color = Color(0.2, 0.7, 0.2)
	
	bottom_pipe.position = Vector2(0, gap_bottom)
	bottom_pipe.size = Vector2(PIPE_WIDTH, screen_height - gap_bottom)
	bottom_pipe.color = Color(0.2, 0.7, 0.2)

func check_collision(bird: Control) -> bool:
	var bird_rect = Rect2(bird.position, bird.size)
	var top_rect = Rect2(position + top_pipe.position, top_pipe.size)
	var bottom_rect = Rect2(position + bottom_pipe.position, bottom_pipe.size)
	return bird_rect.intersects(top_rect) or bird_rect.intersects(bottom_rect)

func check_score(bird: Control) -> bool:
	if scored:
		return false
	if position.x + PIPE_WIDTH < bird.position.x:
		scored = true
		return true
	return false
