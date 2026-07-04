extends TextureRect
@export var this_room: int

const FLAGS := {
	"inka": preload("res://assets/sprites/flags/inka_flag.png"),
	"japan": preload("res://assets/sprites/flags/japan_flag.png"),
	"ww2": preload("res://assets/sprites/flags/ww2_flag.png"),
	"medieval": preload("res://assets/sprites/flags/medieval_flag.png"),
	"soviet": preload("res://assets/sprites/flags/soviet_flag.png"),
}


func _ready() -> void:
	Events.new_floor.connect(change_image)
	var saved := _saved_type()
	if FLAGS.has(saved):
		texture = FLAGS[saved]


func _saved_type() -> String:
	var rooms = SaveManager.museum.showroom
	var i := this_room - 1
	if i >= 0 and i < rooms.size():
		return rooms[i]
	return ""


func change_image(type: String, room_number: int) -> void:
	if room_number == this_room and FLAGS.has(type):
		texture = FLAGS[type]
