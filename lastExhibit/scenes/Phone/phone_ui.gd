extends CanvasLayer


func _on_home_button_pressed() -> void:
	$PhoneFrame.visible = true
	$"Classifieds".visible = false
	$Flappybird.visible = false
	$Tor.visible = false
	$Museum.visible = false
	$Revolut.visible = false
	$Messages.visible = false
	$Settings.visible = false
