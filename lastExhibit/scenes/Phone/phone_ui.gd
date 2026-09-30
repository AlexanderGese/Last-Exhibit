extends CanvasLayer


func _on_home_button_pressed() -> void:
	$PhoneFrame.visible = true
	$"Classifieds".visible = false
	$Flapbird.visible = false
	$Tor.visible = false
	$Museum.visible = false
	$Revospar.visible = false
	$Messages.visible = false
	$Settings.visible = false
