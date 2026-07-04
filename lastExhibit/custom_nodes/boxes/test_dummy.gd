extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var hp = 100
@export var dialogue : DialogueResource
@onready var balloon_scene = preload("res://dialogues/dummys/dummy1.tscn")
var current_balloon = null


func _on_hurtbox_hurt(damage: int, knockback: Vector2) -> void:
	$Label.text = str(hp - damage)
	hp -= damage

func _process(delta: float) -> void:
	if hp <= 0:
		$Label.visible = false
		$RespawnTimer.start(2)
		hp = 1
		$Sprite2D.visible = false
		print("dead")
		set_collision_layer_value(1, false)

func _on_respawn_timer_timeout() -> void:
	print("respawn")
	$Sprite2D.visible = true
	hp = 100
	$Label.text = str(hp)
	$Label.visible = true
	set_collision_layer_value(1, true)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): 
		zeige_balloon()

func signal_started(): 
	#Events.dialogue_started.emit()
	pass
	
func signal_ended():
	#Events.dialogue_ended.emit()
	pass
	
func zeige_balloon(): 
	signal_started()
	current_balloon = balloon_scene.instantiate()
	get_tree().current_scene.add_child(current_balloon)
	current_balloon.start(dialogue, "start", [self])

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		abort_dialogue()
		
func abort_dialogue():
	if current_balloon:
		signal_ended()
		current_balloon.queue_free()
		current_balloon = null


func _on_player_pause() -> void:
	abort_dialogue()
