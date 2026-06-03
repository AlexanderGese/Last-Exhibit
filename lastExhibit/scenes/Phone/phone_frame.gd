extends TextureRect

@onready var großanzeige: TextureRect = $"../Großanzeigen"
@onready var to: TextureRect = $"../Tor"
@onready var flappybird: TextureRect = $"../Flappybird"
@onready var museu: TextureRect = $"../Museum"
@onready var revolu: TextureRect = $"../Revolut"
@onready var message: TextureRect = $"../Messages"
@onready var setting: TextureRect = $"../Settings"
@onready var tor_app: bool
@onready var museum_app: bool
@onready var flappy_app: bool


func _ready() -> void:
	Events.purchase_großanzeigen.connect(_update_apps.bind(type: String))
	
func _update_apps(type: String) -> void:
	pass

func _process(delta: float) -> void:
	tor_app = SaveManager.player.tor_app
	museum_app = SaveManager.player.museum_app
	flappy_app = SaveManager.player.flappy_app
	if tor_app:
		print("tor")
		$HomeScreen/VBoxContainer/SecondRow/Tor.visible = true
	if museum_app:
		print("museum")
		$HomeScreen/VBoxContainer/SecondRow/Museum.visible = true
	if flappy_app:
		print("flappy")
		$HomeScreen/VBoxContainer/ThirdRow/Flappy.visible = true



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
