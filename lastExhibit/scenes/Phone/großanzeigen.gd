extends TextureRect

# WW2 freischalten
func button_1() -> void:
	if SaveManager.buy(10, "WW2 unlock", "time_shards"):
		SaveManager.player.unlocked_epochs.append("ww2")
		SaveManager.player.add_message("Pickup your Upgrade")
		$VBoxContainer/Label.visible = false

# Mittelalter freischalten
func button_2() -> void:
	if SaveManager.buy(25, "Mittelalter", "time_shards"):
		SaveManager.player.unlocked_epochs.append("mittelalter")
		SaveManager.player.add_message("Pickup your Upgrade")
		$VBoxContainer/Label2.visible = false

# Mehr Zeit pro Level
func button_3() -> void:
	if SaveManager.buy(250, "More time", "coins"):
		SaveManager.player.level_time += 30
		$VBoxContainer/Label3.visible = false

# Mehr Zeit pro Level (zweites Upgrade)
func button_4() -> void:
	if SaveManager.buy(250, "More time", "coins"):
		SaveManager.player.level_time += 30
		$VBoxContainer/Label4.visible = false

# Museum-App freischalten
func button_5() -> void:
	if SaveManager.buy(100, "museum app", "coins"):
		SaveManager.player.museum_app = true
		$VBoxContainer/Label5.visible = false
		Events.purchase_großanzeigen.emit("museum")

# Tor-App freischalten
func button_6() -> void:
	if SaveManager.buy(500, "tor app", "coins"):
		SaveManager.player.tor_app = true
		$VBoxContainer/Label6.visible = false
		Events.purchase_großanzeigen.emit("tor")

# Flappy-App freischalten
func button_7() -> void:
	if SaveManager.buy(250, "flappy", "coins"):
		SaveManager.player.flappy_app = true
		$VBoxContainer/Label7.visible = false
		Events.purchase_großanzeigen.emit("flappy")

# Noch frei
func button_8() -> void: pass
func button_9() -> void: pass
func button_10() -> void: pass
