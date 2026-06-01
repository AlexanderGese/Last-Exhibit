extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#Freischalten von WW2
func button_1() -> void:
	var ret = SaveManager.buy(100, "WW2 unlock", "coins")
	if ret:
		SaveManager.player.unlocked_epochs.append("ww2")
		$VBoxContainer/Label.visible = false

#Freischalten von Mittelalter
func button_2() -> void:
	pass # Replace with function body.

#Mehrzeit pro level
func button_3() -> void:
	pass # Replace with function body.

# mehrzeit pro level
func button_4() -> void:
	pass # Replace with function body.

# unlock von museum
func button_5() -> void:
	pass # Replace with function body.

#unlock von tor
func button_6() -> void:
	pass # Replace with function body.

#unlock von flappy bird
func button_7() -> void:
	pass # Replace with function body.

#unlock
func button_8() -> void:
	pass # Replace with function body.

#unlock
func button_9() -> void:
	pass # Replace with function body.

#unlcok
func button_10() -> void:
	pass # Replace with function body.
