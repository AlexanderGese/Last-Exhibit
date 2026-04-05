extends Area2D

var player_collided: bool = false
@onready var anim = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("zeitmaschine")
	anim.play("default")

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_collided = true
		anim.play("open")

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_collided = false
		anim.play("close")

func _process(_delta: float) -> void:
	if player_collided and Input.is_action_just_pressed("interact"):
		var ui = get_tree().get_first_node_in_group("player").get_node("ZeitmaschinenUI")
		if ui.visible:
			ui.do_hide()
		else:
			ui.do_show()
