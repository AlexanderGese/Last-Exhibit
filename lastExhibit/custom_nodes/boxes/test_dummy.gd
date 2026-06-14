extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var hp = 100
	
	


func _on_hurtbox_hurt(damage: int, knockback: Vector2) -> void:
	$Label.text = str(hp - damage)
	hp -= damage

func _process(delta: float) -> void:
	if hp <= 0:
		$RespawnTimer.start(2)
		hp = 1
		$Sprite2D.visible = false
		print("dead")

func _on_respawn_timer_timeout() -> void:
	print("respawn")
	$Sprite2D.visible = true
	hp = 100
	$Label.text = str(hp)
