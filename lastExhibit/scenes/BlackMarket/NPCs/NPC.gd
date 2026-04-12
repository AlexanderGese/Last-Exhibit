# NPC.gd
extends Area2D

@export var npc_name: String = ""
var player_nearby: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_nearby = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_nearby = false

func _process(_delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("interact"):
		_open_shop()

func _open_shop() -> void:
	pass  # wird in jedem NPC überschrieben
