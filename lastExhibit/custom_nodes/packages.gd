extends Node2D

@onready var small_package: Sprite2D = $SmallPackage
@onready var big_package: Sprite2D = $BigPackage
@onready var medium_package: Sprite2D = $MediumPackage

var in_area = false
var amount:=  0
var types: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	types.resize(1000)
	Events.upgrade_purchased.connect(add_upgrade)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_area:
		if Input.is_action_just_pressed("interact"):
			amount = 0
			small_package.visible = false
			medium_package.visible = false
			big_package.visible = false
			while types.is_empty() != true:
				Events.upgrade_collected.emit(types.pop_front())
			SaveManager.player.clear_messages()

func add_upgrade(type: String):
	types.append(type)
	amount += 1
	if amount >= 1:
		small_package.visible = true
	if amount >= 2:
		medium_package.visible = true
	if amount >= 3:
		big_package.visible = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_area = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_area = false
