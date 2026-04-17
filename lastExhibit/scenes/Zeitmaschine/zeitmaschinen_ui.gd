extends Control

const PIN_UNLOCKED = preload("res://assets/sprites/zeitmaschine/GoldenPin.png")
const PIN_LOCKED = preload("res://assets/sprites/zeitmaschine/GreyPin.png")
const PIN_SELECTED = preload("res://assets/sprites/zeitmaschine/RedPin.png")

@onready var time_slider = $NinePatchRect/TimeSlider
@onready var time_label = $NinePatchRect/TimeLabel

@onready var pins = {
	"inka":        $NinePatchRect/MapTexture/Pin_Inka,
	"mittelalter": $NinePatchRect/MapTexture/Pin_Mittelalter,
	"samurai":     $NinePatchRect/MapTexture/Pin_Samurai,
	"ww2":         $NinePatchRect/MapTexture/Pin_WW2,
	"sowjet":      $NinePatchRect/MapTexture/Pin_Sowjet,
}

const EPOCH_RANGES = {
	"inka":        [0, 20],
	"mittelalter": [20, 40],
	"samurai":     [40, 60],
	"ww2":         [60, 80],
	"sowjet":      [80, 100],
}

const EPOCH_YEARS = {
	"inka":        "vor 1532",
	"mittelalter": "~1200",
	"samurai":     "1600–1868",
	"ww2":         "1943",
	"sowjet":      "1960–1980",
}

var selected_epoch: String = ""

func _ready() -> void:
	hide()
	_update_pins(time_slider.value)

func do_show() -> void:
	get_parent().set_physics_process(false)
	show()

func do_hide() -> void:
	get_parent().set_physics_process(true)
	hide()

func _on_time_slider_value_changed(value: float) -> void:
	_update_pins(value)

func _update_pins(value: float) -> void:
	var unlocked = SaveManager.player.unlocked_epochs
	for epoch in EPOCH_RANGES:
		var range = EPOCH_RANGES[epoch]
		var pin = pins[epoch]
		if value >= range[0] and value <= range[1]:
			pin.visible = true
			time_label.text = EPOCH_YEARS[epoch]
			if epoch == selected_epoch:
				pin.texture = PIN_SELECTED
			elif epoch in unlocked:
				pin.texture = PIN_UNLOCKED
			else:
				pin.texture = PIN_LOCKED
		else:
			pin.visible = false

func _on_pin_clicked(epoch: String) -> void:
	var unlocked = SaveManager.player.unlocked_epochs
	if not epoch in unlocked:
		return
	selected_epoch = epoch
	pins[epoch].texture = PIN_SELECTED
	await get_tree().create_timer(0.8).timeout
	do_hide()
	await Fader.fade_out(1.0)
	match epoch:
		"sowjet":
			get_tree().change_scene_to_file("res://scenes/Epochs/sowjet/sowjet.tscn")

func _on_pin_sowjet_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_on_pin_clicked("sowjet")

func _on_pin_ww2_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_on_pin_clicked("ww2")

func _on_pin_mittelalter_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_on_pin_clicked("mittelalter")

func _on_pin_samurai_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_on_pin_clicked("samurai")

func _on_pin_inka_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_on_pin_clicked("inka")
