extends CanvasLayer

@export var scroll_speed : float = 200.0
@onready var finished_game:bool = SaveManager.player.finished_game
@onready var vbox = $VBoxContainer
@onready var run:bool = false
func _ready() -> void:
	await get_tree().process_frame
	vbox.position.y = get_viewport().size.y
	Events.credits.connect(go)

func go():
	visible = true
	run = true
	SaveManager.player.finished_game = true
	finished_game = true

func _process(delta: float) -> void:
	if run:
		vbox.position.y -= scroll_speed * delta
		if vbox.position.y + vbox.size.y < 0:
			run = false
			visible = false
