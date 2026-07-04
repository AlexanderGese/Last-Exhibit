extends TextureRect
@export var this_room:int
@onready var image_floor: TextureRect = $"."
const INKA_FLAG = preload("res://assets/sprites/flags/inka_flag.png")
const JAPAN_FLAG = preload("res://assets/sprites/flags/japan_flag.png")
const MEDIEVAL_FLAG = preload("res://assets/sprites/flags/medieval_flag.png")
const SOVIET_FLAG = preload("res://assets/sprites/flags/soviet_flag.png")
const WW_2_FLAG = preload("res://assets/sprites/flags/ww2_flag.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.new_floor.connect(change_image)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func change_image(type: String, room_number: int):
	if room_number == this_room:
		if type == "japan":
			image_floor.texture = JAPAN_FLAG
		elif type == "ww2":
			image_floor.texture = WW_2_FLAG
		elif type == "medieval":
			image_floor.texture = MEDIEVAL_FLAG
		elif type == "soviet":
			image_floor.texture = SOVIET_FLAG
	pass
