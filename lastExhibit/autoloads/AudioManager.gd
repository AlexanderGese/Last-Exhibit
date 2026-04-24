# res://autoloads/AudioManager.gd
extends Node

@onready var music_player = $MusicPlayer
@onready var sfx_player = $SFXPlayer

var current_track: String = ""

const TRACKS = {
	"museum_day":    "res://assets/audio/music/museum_day.ogg",
	"museum_night":  "res://assets/audio/music/museum_night.ogg",
	"soviet":        "res://assets/audio/music/soviet.ogg",
	"soviet_boss":   "res://assets/audio/music/soviet_boss.ogg",
	"ww2":           "res://assets/audio/music/ww2.ogg",
	"ww2_boss":      "res://assets/audio/music/ww2_boss.ogg",
	"medieval":      "res://assets/audio/music/medieval.ogg",
	"medieval_boss": "res://assets/audio/music/medieval_boss.ogg",
	"samurai":       "res://assets/audio/music/samurai.ogg",
	"samurai_boss":  "res://assets/audio/music/samurai_boss.ogg",
	"inka":          "res://assets/audio/music/inka.ogg",
	"inka_boss":     "res://assets/audio/music/inka_boss.ogg",
	"blackmarket":   "res://assets/audio/music/blackmarket.ogg",
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
