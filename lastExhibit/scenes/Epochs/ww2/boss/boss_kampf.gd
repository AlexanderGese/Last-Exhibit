extends Node2D

@onready var trigger_zone = $TriggerZone
@onready var animation_player = $AnimationPlayer

var boss_kampf_gestartet : bool = false

func _process(delta):
	if boss_kampf_gestartet:
		return
		
	var bodies = trigger_zone.get_overlapping_bodies()
	
	if bodies.size() > 0:
		for body in bodies:
			if body.is_in_group("player"):
				boss_kampf_gestartet = true
				start_boss_intro()
				break

func start_boss_intro():
	
	var spieler = get_tree().get_first_node_in_group("player")
	if spieler:
		var wand_links_x = $WrackLinks/CollisionShape2D.global_position.x
		var wand_rechts_x = $WrackRechts/CollisionShape2D.global_position.x
		var sicherheits_abstand = 120.0
		
		if abs(spieler.global_position.x - wand_links_x) < abs(spieler.global_position.x - wand_rechts_x):
			spieler.global_position.x = wand_links_x + sicherheits_abstand
		else:
			spieler.global_position.x = wand_rechts_x - sicherheits_abstand
			
		if spieler.has_method("reset_physics_interpolation"):
			spieler.reset_physics_interpolation()

	animation_player.play("introCrash")
	await animation_player.animation_finished
	start_boss_flugzeug()

func start_boss_flugzeug():
	pass
