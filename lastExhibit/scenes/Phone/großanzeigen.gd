extends TextureRect


func _ready() -> void:
	_refresh_labels()


func _refresh_labels() -> void:
	$VBoxContainer/Label.visible = not _has_epoch("ww2")
	$VBoxContainer/Label2.visible = not _has_epoch("mittelalter")
	$VBoxContainer/Label8.visible = not _has_epoch("japan")
	$VBoxContainer/Label5.visible = not SaveManager.player.museum_app
	$VBoxContainer/Label6.visible = not SaveManager.player.tor_app
	$VBoxContainer/Label7.visible = not SaveManager.player.flappy_app


func button_1() -> void:
	if SaveManager.buy(15, "WW2 unlock", "time_shards"):
		Events.upgrade_purchased.emit("WW2")
		SaveManager.player.add_message("Pickup your Upgrade")
		$VBoxContainer/Label.visible = false


func reset_all_upgrades() -> void:
	# Epochen zurücksetzen (außer "sowjet" als Start-Epoche behalten)
	SaveManager.player.unlocked_epochs.clear()
	SaveManager.player.unlocked_epochs.append("sowjet")

	# Apps zurücksetzen
	SaveManager.player.museum_app = false
	SaveManager.player.tor_app = false
	SaveManager.player.flappy_app = false

	# Time-Upgrades zurücksetzen (level_time auf Default)
	SaveManager.player.level_time = 60  # oder was dein Default ist

	# Pending Upgrades im Lastenaufzug clearen
	if "pending_upgrades" in SaveManager.player:
		SaveManager.player.pending_upgrades.clear()

	# Save
	SaveManager.save_all()

	# Phone aktualisieren (App-Icons verschwinden)
	Events.purchase_großanzeigen.emit("reset")

	# Labels wieder sichtbar machen
	_refresh_labels()


func _has_epoch(epoch: String) -> bool:
	return SaveManager.player.unlocked_epochs.has(epoch)


# Mittelalter freischalten
func button_2() -> void:
	if SaveManager.buy(40, "Mittelalter", "time_shards"):
		Events.upgrade_purchased.emit("Mittelalter")
		SaveManager.player.add_message("Pickup your Upgrade")
		$VBoxContainer/Label2.visible = false


# Mehr Zeit pro Level
func button_3() -> void:
	if SaveManager.buy(250, "More time", "coins"):
		Events.upgrade_purchased.emit("Time")
		SaveManager.player.add_message("Pickup your Upgrade")
		$VBoxContainer/Label3.visible = false


# Mehr Zeit pro Level (zweites Upgrade)
func button_4() -> void:
	if SaveManager.buy(250, "More time", "coins"):
		Events.upgrade_purchased.emit("Time")
		SaveManager.player.add_message("Pickup your Upgrade")
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


func button_8() -> void:
	if SaveManager.buy(25, "japan", "time_shards"):
		Events.upgrade_purchased.emit("japan")
		SaveManager.player.add_message("Pickup your Upgrade")
		$VBoxContainer/Label8.visible = false


func button_9() -> void:
	pass


func button_10() -> void:
	pass
