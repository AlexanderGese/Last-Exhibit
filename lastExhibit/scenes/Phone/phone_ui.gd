extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_home_button_pressed() -> void:
	$PhoneFrame.visible = true
	$"Großanzeigen".visible = false
	$Flappybird.visible = false
	$Tor.visible = false
	$Museum.visible = false
	$Revolut.visible = false
	$Messages.visible = false
	$Settings.visible = false
