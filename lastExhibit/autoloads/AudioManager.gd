extends Node

var current_player: AudioStreamPlayer
var current_track: String = ""

const TRACKS = {
	"museum_day": "res://assets/music/MuseumDay.ogg",
	"museum_night": "res://assets/music/MuseumNight.ogg",
	"soviet": "res://assets/music/SowjetLevel.ogg",
	"soviet_boss": "res://assets/music/SowjetBoss.ogg",
	"ww2": "res://assets/music/WW2Level.ogg",
	"ww2_boss": "res://assets/music/WW2Boss.ogg",
	"medieval": "res://assets/music/MedivalLevel.ogg",
	"medieval_boss": "res://assets/music/MedivalBoss.ogg",
	"samurai": "res://assets/music/JapanLevel.ogg",
	"samurai_boss": "res://assets/music/JapanBoss.ogg",
	"inka": "res://assets/music/InkaLevel.ogg",
	"inka_boss": "res://assets/music/InkaBoss.ogg",
	"blackmarket": "res://assets/music/BlackMarketMusic.ogg",
	"trailer": "res://assets/music/TrailerMusic.ogg",
	"final": "res://assets/music/final.ogg",
}

const AUDIO_PATH = "user://audio.dat"

var _default_volumes := {}


func _ready() -> void:
	for b in ["Master", "Music", "VFX"]:
		var idx := AudioServer.get_bus_index(b)
		if idx >= 0:
			_default_volumes[b] = clampf(db_to_linear(AudioServer.get_bus_volume_db(idx)), 0.0, 1.0)
	current_player = AudioStreamPlayer.new()
	current_player.bus = "Music"
	add_child(current_player)
	_load_audio()


func play(track_name: String, crossfade: float = 2.0) -> void:
	if not TRACKS.has(track_name):
		return
	if current_track == track_name:
		return
	current_track = track_name

	# Neuen Player erstellen
	var new_player = AudioStreamPlayer.new()
	new_player.bus = "Music"
	add_child(new_player)
	new_player.stream = load(TRACKS[track_name])
	if "loop" in new_player.stream:
		new_player.stream.loop = true
	new_player.volume_db = -80
	new_player.play()

	# Crossfade
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(current_player, "volume_db", -80, crossfade)
	tween.tween_property(new_player, "volume_db", 0, crossfade)
	await tween.finished

	# Alten entfernen
	current_player.queue_free()
	current_player = new_player


func play_sfx(path: String) -> void:
	var sfx = AudioStreamPlayer.new()
	sfx.bus = "VFX"
	add_child(sfx)
	sfx.stream = load(path)
	sfx.play()
	await sfx.finished
	sfx.queue_free()


func set_volume(bus: String, linear: float) -> void:
	var idx := AudioServer.get_bus_index(bus)
	if idx < 0:
		return
	AudioServer.set_bus_volume_db(idx, -80.0 if linear <= 0.001 else linear_to_db(linear))
	_save_audio()


func get_volume(bus: String) -> float:
	var idx := AudioServer.get_bus_index(bus)
	if idx < 0:
		return 1.0
	return clampf(db_to_linear(AudioServer.get_bus_volume_db(idx)), 0.0, 1.0)


func reset_audio() -> void:
	for b in _default_volumes.keys():
		var idx := AudioServer.get_bus_index(b)
		if idx >= 0:
			var lin := float(_default_volumes[b])
			AudioServer.set_bus_volume_db(idx, -80.0 if lin <= 0.001 else linear_to_db(lin))
	_save_audio()


func _save_audio() -> void:
	var data := {}
	for b in ["Master", "Music", "VFX"]:
		data[b] = get_volume(b)
	var f := FileAccess.open(AUDIO_PATH, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(data))


func _load_audio() -> void:
	if not FileAccess.file_exists(AUDIO_PATH):
		return
	var f := FileAccess.open(AUDIO_PATH, FileAccess.READ)
	if not f:
		return
	var data = JSON.parse_string(f.get_as_text())
	if typeof(data) != TYPE_DICTIONARY:
		return
	for b in data.keys():
		var idx := AudioServer.get_bus_index(b)
		if idx >= 0:
			var lin := float(data[b])
			AudioServer.set_bus_volume_db(idx, -80.0 if lin <= 0.001 else linear_to_db(lin))
