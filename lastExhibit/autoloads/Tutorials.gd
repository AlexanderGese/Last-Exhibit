extends CanvasLayer

const OVERLAY := preload("res://scenes/GUI/TutorialOverlay.tscn")

const TUTORIALS := {
	"levels": {"title": "The Heist", "body": "You are in the past. Grab artifacts and time-shards, then get back before the timer runs out. When it reaches zero the night ends and your museum earns a day of money."},
	"grossanzeigen": {"title": "Shop", "body": "This is the shop. Use your coins and time-shards to unlock new time periods, phone apps, and upgrades. More things appear as you play."},
	"messages": {"title": "Messages", "body": "Your text messages show up here. The game sends you hints and reminders. Check them after something big happens."},
	"revolut": {"title": "Bank", "body": "This is your bank. It shows your coins, time-shards, and Bitcoin, plus your last few payments."},
	"settings": {"title": "Settings", "body": "Change your keys here. You can also reset your whole game back to the start."},
	"tor": {"title": "Darknet", "body": "This is the secret dark web shop. Sell the artifacts you stole for Bitcoin, and buy shady items. Only valuable artifacts can be sold."},
	"museum": {"title": "Museum", "body": "This shows how your museum is doing: visitors per day, your reputation, the ticket price, and the money you make each day."},
	"flappy": {"title": "Flappy", "body": "A small game to relax. Every 10 points you score gives you 1 coin."},
	"first_artifact": {"title": "Artifacts", "body": "You grabbed an artifact! Take it back to your museum and place it in a showcase to draw visitors, or sell it on the Darknet for Bitcoin."},
	"first_boss": {"title": "Boss Fight", "body": "This is a boss. It hits hard and has a lot of health. Dodge its attacks and keep hitting it. Beat it for a big reward."},
}

var _overlay
var _current_id := ""


func _ready() -> void:
	layer = 100
	_overlay = OVERLAY.instantiate()
	add_child(_overlay)
	_overlay.dismissed.connect(_on_dismissed)


func show_tutorial(id: String) -> void:
	if not TUTORIALS.has(id):
		return
	if SaveManager.player and id in SaveManager.player.seen_tutorials:
		return
	_current_id = id
	_overlay.show_content(TUTORIALS[id]["title"], TUTORIALS[id]["body"])


func _on_dismissed() -> void:
	if _current_id != "" and SaveManager.player and not _current_id in SaveManager.player.seen_tutorials:
		SaveManager.player.seen_tutorials.append(_current_id)
		SaveManager.save_all()
	_current_id = ""
