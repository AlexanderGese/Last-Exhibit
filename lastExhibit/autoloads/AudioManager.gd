# res://autoloads/AudioManager.gd
extends Node

@onready var music_player = $MusicPlayer
@onready var sfx_player = $SFXPlayer

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
}

func play(track_name: String, fade: bool = true) -> void:
	if current_track == track_name:
		return
	current_track = track_name
	if fade:
		await _fade_out()
	music_player.stream = load(TRACKS[track_name])
	music_player.play()
	if fade:
		await _fade_in()

func play_sfx(path: String) -> void:
	sfx_player.stream = load(path)
	sfx_player.play()

func _fade_out(duration: float = 1.0) -> void:
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", -80, duration)
	await tween.finished

func _fade_in(duration: float = 1.0) -> void:
	music_player.volume_db = -80
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", 0, duration)
	await tween.finished
