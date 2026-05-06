extends Node

var current_player: AudioStreamPlayer
var current_track: String = ""

const TRACKS = {
	"museum_day":    "res://assets/music/MuseumDay.ogg",
	"museum_night":  "res://assets/music/MuseumNight.ogg",
	"soviet":        "res://assets/music/SowjetLevel.ogg",
	"soviet_boss":   "res://assets/music/SowjetBoss.ogg",
	"ww2":           "res://assets/music/WW2Level.ogg",
	"ww2_boss":      "res://assets/music/WW2Boss.ogg",
	"medieval":      "res://assets/music/MedivalLevel.ogg",
	"medieval_boss": "res://assets/music/MedivalBoss.ogg",
	"samurai":       "res://assets/music/JapanLevel.ogg",
	"samurai_boss":  "res://assets/music/JapanBoss.ogg",
	"inka":          "res://assets/music/InkaLevel.ogg",
	"inka_boss":     "res://assets/music/InkaBoss.ogg",
	"blackmarket":   "res://assets/music/BlackMarketMusic.ogg",
	"trailer" :      "res://assets/music/TrailerMusic.ogg",
}

func _ready() -> void:
	current_player = AudioStreamPlayer.new()
	add_child(current_player)

func play(track_name: String, crossfade: float = 2.0) -> void:
	return
	if current_track == track_name:
		return
	current_track = track_name

	# Neuen Player erstellen
	var new_player = AudioStreamPlayer.new()
	add_child(new_player)
	new_player.stream = load(TRACKS[track_name])
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
	add_child(sfx)
	sfx.stream = load(path)
	sfx.play()
	await sfx.finished
	sfx.queue_free()
