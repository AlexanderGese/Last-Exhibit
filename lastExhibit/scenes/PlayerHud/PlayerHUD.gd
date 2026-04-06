# PlayerHUD.gd
extends Control

@onready var health_bg = $BottomLeft/HealthBarContainer/HealthBarBG
@onready var health_fill = $BottomLeft/HealthBarContainer/HealthBarFill
@onready var health_label = $BottomLeft/HealthBarContainer/Label
@onready var money_label = $TopLeft/MoneyContainer/MoneyLabel
@onready var shards_label = $TopLeft/ShardsContainer/ShardsLabel
@onready var time_label = $TopRight/TimeContainer/TimeLabel

var save: PlayerSaveFile

func _ready() -> void:
	save = SaveManager.player
	GameClock.time_changed.connect(_on_time_changed)
	time_label.text = GameClock.get_formatted_time()
	refresh()

func refresh() -> void:
	var health_percent = save.hp / save.max_hp
	health_fill.scale.x = health_percent
	health_label.text = str(int(save.hp)) + "/" + str(int(save.max_hp))
	money_label.text = str(save.money)
	shards_label.text = str(save.time_shards)

func _on_time_changed(formatted: String) -> void:
	time_label.text = formatted

func _process(_delta: float) -> void:
	refresh()
