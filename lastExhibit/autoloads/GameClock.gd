extends Node

var game_minutes: int = 1320
var is_night: bool = true
var timer: float = 0.0
var _loaded: bool = false

const REAL_SECONDS_PER_GAME_10MIN = 18.75
const NIGHT_START_MINUTES = 1320  # 22:00
const DAY_START_MINUTES = 360  # 06:00
const MINUTES_PER_DAY = 1440

signal time_changed(formatted: String)
signal day_started
signal night_started


func _process(delta: float) -> void:
	if not _loaded:
		if SaveManager.player != null:
			print("Lade game_minutes: ", SaveManager.player.game_minutes)
			game_minutes = SaveManager.player.game_minutes
			_loaded = true
			# Phase initial korrekt setzen ohne Signal zu spammen
			is_night = _is_night_time(game_minutes)
		return

	timer += delta
	if timer < REAL_SECONDS_PER_GAME_10MIN:
		return

	timer = 0.0
	game_minutes += 10
	if game_minutes >= MINUTES_PER_DAY:
		game_minutes = 0

	SaveManager.player.game_minutes = game_minutes
	_check_phase()  # checkt ob Phase wechselt
	time_changed.emit(get_formatted_time())
	SaveManager.save_all()  # einmal pro 10-Min-Schritt, am Ende


func _is_night_time(minutes: int) -> bool:
	return minutes >= NIGHT_START_MINUTES or minutes < DAY_START_MINUTES


func _check_phase() -> void:
	var should_be_night = _is_night_time(game_minutes)
	if should_be_night == is_night:
		return  # keine Änderung

	is_night = should_be_night
	if is_night:
		SaveManager.museum.current_night += 1
		night_started.emit()
	else:
		day_started.emit()


func get_formatted_time() -> String:
	var h = game_minutes / 60 % 12
	if h == 0:
		h = 12
	var m = game_minutes % 60
	var period = "AM" if game_minutes < 720 else "PM"
	return "%02d:%02d %s" % [h, m, period]
