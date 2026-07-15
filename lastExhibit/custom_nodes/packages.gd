extends Node2D

@onready var small_package: Sprite2D = $SmallPackage
@onready var big_package: Sprite2D = $BigPackage
@onready var medium_package: Sprite2D = $MediumPackage

var in_area: bool = false


func _ready() -> void:
	Events.upgrade_purchased.connect(_on_upgrade_purchased)
	_refresh_visuals()


func _process(_delta: float) -> void:
	if in_area and Input.is_action_just_pressed("interact"):
		_collect_all()


func _on_upgrade_purchased(_type: String) -> void:
	_refresh_visuals()
	Tutorials.show_tutorial("collect_package")


func _collect_all() -> void:
	var pending: Array[String] = SaveManager.player.pending_upgrades.duplicate()
	if pending.is_empty():
		return
	for type in pending:
		Events.upgrade_collected.emit(type)
	SaveManager.player.pending_upgrades.clear()
	SaveManager.save_all()
	SaveManager.player.clear_messages()
	_refresh_visuals()


func _refresh_visuals() -> void:
	var count := SaveManager.player.pending_upgrades.size()
	small_package.visible = count >= 1
	medium_package.visible = count >= 2
	big_package.visible = count >= 3


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_area = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_area = false
