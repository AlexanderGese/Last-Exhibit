extends TextureRect

@onready var großanzeige: TextureRect = $"../Großanzeigen"
@onready var to: TextureRect = $"../Tor"
@onready var flappybird: TextureRect = $"../Flappybird"
@onready var museu: TextureRect = $"../Museum"
@onready var revolu: TextureRect = $"../Revolut"
@onready var message: TextureRect = $"../Messages"
@onready var setting: TextureRect = $"../Settings"



func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func großanzeigen() -> void:
	großanzeige.visible = true
	

func flappy() -> void:
	flappybird.visible = true


func button() -> void:
	to.visible = true


func museum() -> void:
	museu.visible = true


func revolut() -> void:
	revolu.visible = true


func messages() -> void:
	message.visible = true


func settings() -> void:
	setting.visible = true
