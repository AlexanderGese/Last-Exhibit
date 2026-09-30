extends TextureRect

# App-Screens (die ganze App-Oberflächen die sich öffnen)
@onready var classifieds: TextureRect = $"../Classifieds"
@onready var to: TextureRect = $"../Tor"
@onready var flapbird_panel: TextureRect = $"../Flapbird"
@onready var museu: TextureRect = $"../Museum"
@onready var revospar_panel: TextureRect = $"../Revospar"
@onready var message: TextureRect = $"../Messages"
@onready var setting: TextureRect = $"../Settings"

# App-Icons auf dem Homescreen (die freigeschaltet werden können)
@onready var tor_icon = $HomeScreen/VBoxContainer/SecondRow/Tor
@onready var museum_icon = $HomeScreen/VBoxContainer/SecondRow/Museum
@onready var flapbird_icon = $HomeScreen/VBoxContainer/ThirdRow/Flapbird


func _ready() -> void:
	Events.purchase_großanzeigen.connect(_on_app_purchased)
	_update_all_apps()


func _on_app_purchased(_type: String) -> void:
	_update_all_apps()


func _update_all_apps() -> void:
	tor_icon.visible = SaveManager.player.tor_app
	museum_icon.visible = SaveManager.player.museum_app
	flapbird_icon.visible = SaveManager.player.flapbird_app


# App-Screens öffnen
func großanzeigen() -> void:
	classifieds.visible = true
	Tutorials.show_tutorial("grossanzeigen")


func flapbird() -> void:
	flapbird_panel.visible = true
	Tutorials.show_tutorial("flapbird")


func button() -> void:
	to.visible = true
	Tutorials.show_tutorial("tor")


func museum() -> void:
	museu.visible = true
	Tutorials.show_tutorial("museum")


func revospar() -> void:
	revospar_panel.visible = true
	Tutorials.show_tutorial("revospar")


func messages() -> void:
	message.visible = true
	Tutorials.show_tutorial("messages")


func settings() -> void:
	setting.visible = true
	Tutorials.show_tutorial("settings")
