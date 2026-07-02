extends Node

const SOUNDS = {
	"hit": "res://assets/audio/sfx/player/Hitenemy.wav",
	"jump": "res://assets/audio/sfx/player/Jump.wav",
	"shoot_pistol" : "res://assets/audio/sfx/player/Pistol.wav",
	"shoot_gun" : "res://assets/audio/sfx/player/Rifle.mp3",
	"interact" : "res://assets/audio/sfx/player/place.wav"
}

var players: Dictionary = {}


func _ready() -> void:
	for name in SOUNDS:
		var player = AudioStreamPlayer.new()
		player.stream = load(SOUNDS[name])
		add_child(player)
		players[name] = player


func play(name: String) -> void:
	if players.has(name):
		players[name].play()


func stop(name: String) -> void:
	if players.has(name):
		players[name].stop()
