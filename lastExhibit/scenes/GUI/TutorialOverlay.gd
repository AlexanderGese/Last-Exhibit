extends Control

signal dismissed

@onready var _title: Label = $Balloon/Panel/Inner/VBox/Title
@onready var _body: Label = $Balloon/Panel/Inner/VBox/Body


func _ready() -> void:
	visible = false
	$Balloon/Panel/Inner/VBox/OK.pressed.connect(_on_ok)


func show_content(title_text: String, body_text: String) -> void:
	_title.text = title_text
	_body.text = body_text
	visible = true


func _on_ok() -> void:
	visible = false
	dismissed.emit()
