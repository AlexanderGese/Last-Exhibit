extends Node

var game_minutes: int = 1320
var is_night: bool = true
var timer: float = 0.0
var _loaded: bool = false
const REAL_SECONDS_PER_GAME_10MIN = 18.75

signal time_changed(formatted: String)
signal day_started
signal night_started

func _process(delta: float) -> void:
	if not _loaded:
		if SaveManager.player != null:
			print("Lade game_minutes: ", SaveManager.player.game_minutes)
			game_minutes = SaveManager.player.game_minutes
			_loaded = true
		return
	timer += delta
	if timer >= REAL_SECONDS_PER_GAME_10MIN:
		timer = 0.0
		game_minutes += 10
		if game_minutes >= 1440:
			game_minutes = 0
		SaveManager.player.game_minutes = game_minutes
		SaveManager.save_all(0)  # jeden 10-Minuten-Schritt
		_check_phase()
		time_changed.emit(get_formatted_time())

func _check_phase() -> void:
	if game_minutes >= 360 and game_minutes < 1320 and is_night:
		is_night = false
		day_started.emit()
		SaveManager.save_all(0)
	elif (game_minutes >= 1320 or game_minutes < 360) and not is_night:
		is_night = true
		SaveManager.museum.current_night += 1
		night_started.emit()
		SaveManager.save_all(0)

func get_formatted_time() -> String:
	var h = game_minutes / 60 % 12
	if h == 0: h = 12
	var m = game_minutes % 60
	var period = "AM" if game_minutes < 720 else "PM"
	return "%02d:%02d %s" % [h, m, period]
