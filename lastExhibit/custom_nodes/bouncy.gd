extends Node2D

@export var bounce_force: float = -1200.0

@onready var upper: Area2D = $UpperArea
@onready var lower: Area2D = $LowerArea

var player_in_upper := false

func _ready() -> void:
	upper.body_entered.connect(_on_upper_entered)
	upper.body_exited.connect(_on_upper_exited)
	lower.body_entered.connect(_on_lower_entered)

func _on_upper_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_upper = true

func _on_upper_exited(body: Node) -> void:
	if body.is_in_group("player"):
		# Kleiner Delay damit lower noch triggern kann
		await get_tree().create_timer(0.1).timeout
		player_in_upper = false

func _on_lower_entered(body: Node) -> void:
	if body.is_in_group("player") and body is CharacterBody2D:
		if player_in_upper:
			body.bounce(bounce_force)
