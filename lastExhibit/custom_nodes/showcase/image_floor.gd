extends TextureRect
@export var this_room:int
@onready var image_floor: TextureRect = $"."
const INKA_FLAG = preload("uid://nylx61lipog")
const JAPAN_FLAG = preload("uid://ywgxjyaon4co")
const MEDIEVAL_FLAG = preload("uid://clsnlk4jvaeb8")
const SOVIET_FLAG = preload("uid://7xwt6srdmn1")
const WW_2_FLAG = preload("uid://c70f6oraieryh")

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
