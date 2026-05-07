extends Node2D


const HOLD_THRESHOLD := 0.5

var hold_start := 0.0
var is_holding := false
var hold_completed := false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		hold_start = Time.get_ticks_msec() / 1000.0
		is_holding = true
		hold_completed = false

	if is_holding and Input.is_action_pressed("interact"):
		if (Time.get_ticks_msec() / 1000.0) - hold_start >= HOLD_THRESHOLD:
			_kaufen()
			hold_completed = true
			is_holding = false

	if Input.is_action_just_released("interact"):
		if is_holding and not hold_completed:
			_scrollen()
		is_holding = false
