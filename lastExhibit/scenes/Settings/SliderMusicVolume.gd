extends HSlider

@onready var bus_name := "Music"
@onready var bus_index := AudioServer.get_bus_index(bus_name)

func _ready():
	value_changed.connect(_on_value_changed)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index)) * 100

func _on_value_changed(value: float) -> void:
	var linear := value / 100.0

	if linear <= 0.001:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(linear))
