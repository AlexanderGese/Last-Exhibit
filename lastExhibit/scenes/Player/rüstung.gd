extends Node2D
# Rüstung — drives the four cosmetic armor layers (hat / top / bottom / shoes) so
# they mirror the body's current animation and frame, in whatever colour is equipped.
#
# Equipped state is read live from SaveManager.inventory.equipped (head/body/legs/feet).
# Each armor item's id encodes the animation colour, e.g.
#   "ruestung_hat_green_2"  ->  colour "green_2"  ->  animation "1idle hat green_2".
#
# We copy the body's .frame index directly (clamped to the part's frame count) instead
# of play()-ing the part, so armor stays perfectly in sync even where the body and the
# armor have different frame counts / speeds (e.g. body "jump" has 11 frames, armor 6).

# body animation name -> armor action-row token
const ROW := {
	"idle": "1idle",
	"hit": "2punch",
	"jump": "3jump",
	"walk": "4walk",
	"climb": "5climb",
	"shoot_gun": "6shoot",
	"shoot_pistol": "7shoot_2",
}

# equip-slot key -> [part sprite, animation part-token]
@onready var _parts := {
	"head": [$hat/AnimatedSprite2D, "hat"],
	"body": [$top/AnimatedSprite2D, "top"],
	"legs": [$bottom/AnimatedSprite2D, "bottom"],
	"feet": [$shoes/AnimatedSprite2D, "shoes"],
}

@onready var _body: AnimatedSprite2D = get_parent().get_node("AnimatedSprite2D")


func _ready() -> void:
	# We drive .frame manually — stop each part so it never advances on its own.
	for key in _parts:
		var spr: AnimatedSprite2D = _parts[key][0]
		spr.stop()
		spr.speed_scale = 0.0


func _process(_delta: float) -> void:
	var row: String = ROW.get(String(_body.animation), "")
	for key in _parts:
		_sync(_parts[key][0], _parts[key][1], key, row)


func _sync(spr: AnimatedSprite2D, part_token: String, slot_key: String, row: String) -> void:
	var item = SaveManager.inventory.equipped.get(slot_key)
	if item == null or row == "":
		spr.visible = false
		return

	var target := "%s %s %s" % [row, part_token, _color_of(item, part_token)]
	var sf := spr.sprite_frames
	if sf == null or not sf.has_animation(target):
		spr.visible = false
		return

	spr.visible = true
	if String(spr.animation) != target:
		spr.animation = target
	spr.flip_h = _body.flip_h
	var fc := sf.get_frame_count(target)
	spr.frame = min(_body.frame, fc - 1) if fc > 0 else 0


func _color_of(item, part_token: String) -> String:
	# "ruestung_hat_green_2" -> "green_2"
	return String(item.id).trim_prefix("ruestung_%s_" % part_token)
