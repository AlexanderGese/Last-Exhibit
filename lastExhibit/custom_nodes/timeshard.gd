extends Area2D

var in_area:= false
@export var amount:= 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_area and Input.is_action_just_pressed("interact"):
		in_area = false
		$CollisionShape2D.disabled = true
		SaveManager.player.time_shards += amount
		$Sprite2D.visible = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_area = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_area = false
