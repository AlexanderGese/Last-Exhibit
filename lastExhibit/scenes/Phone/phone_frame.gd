extends TextureRect

# App-Screens (die ganze App-Oberflächen die sich öffnen)
@onready var großanzeige: TextureRect = $"../Großanzeigen"
@onready var to: TextureRect = $"../Tor"
@onready var flappybird: TextureRect = $"../Flappybird"
@onready var museu: TextureRect = $"../Museum"
@onready var revolu: TextureRect = $"../Revolut"
@onready var message: TextureRect = $"../Messages"
@onready var setting: TextureRect = $"../Settings"

# App-Icons auf dem Homescreen (die freigeschaltet werden können)
@onready var tor_icon = $HomeScreen/VBoxContainer/SecondRow/Tor
@onready var museum_icon = $HomeScreen/VBoxContainer/SecondRow/Museum
@onready var flappy_icon = $HomeScreen/VBoxContainer/ThirdRow/Flappy

func _ready() -> void:
	Events.purchase_großanzeigen.connect(_on_app_purchased)
	_update_all_apps()
	
func _on_app_purchased(_type: String) -> void:
	_update_all_apps()

func _update_all_apps() -> void:
	tor_icon.visible = SaveManager.player.tor_app
	museum_icon.visible = SaveManager.player.museum_app
	flappy_icon.visible = SaveManager.player.flappy_app

# App-Screens öffnen
func großanzeigen() -> void:
	großanzeige.visible = true
	Tutorials.show_tutorial("grossanzeigen")
func flappy() -> void:
	flappybird.visible = true
	Tutorials.show_tutorial("flappy")
func button() -> void:
	to.visible = true
	Tutorials.show_tutorial("tor")
func museum() -> void:
	museu.visible = true
	Tutorials.show_tutorial("museum")
func revolut() -> void:
	revolu.visible = true
	Tutorials.show_tutorial("revolut")
func messages() -> void:
	message.visible = true
	Tutorials.show_tutorial("messages")
func settings() -> void:
	setting.visible = true
	Tutorials.show_tutorial("settings")
