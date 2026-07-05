extends Node2D

@onready var trigger_zone = $TriggerZone
@onready var animation_player = $AnimationPlayer
@onready var helm: ItemPickup = $Helm
@onready var purpleheart: ItemPickup = $PurpleHeart

var boss_leben : int = 300
@onready var boss_flugzeug = $BossFlugzeug
var boss_aktiv : bool = false

const FLASH_COLOR := Color(2.5, 0.3, 0.3, 1)
const ORIGINAL_MODULATE := Color.WHITE
var flash_tween: Tween = null
@onready var boss_wrack: Sprite2D = $BossWrack
@export var geschwindigkeit: float = 300.0
@export var grenze_links: float = 6200.0
@export var grenze_rechts: float = 8000.0
var ist_tot: bool = false

var fliegt_nach_links: bool = true
var absturz_nach_links: bool = true

@export var kugel_szene: PackedScene = preload("res://custom_nodes/boxes/bullet_ww2.tscn")
@export var schuss_cooldown: float = 1.0
var kann_schiessen: bool = true
@onready var muendung = $BossFlugzeug/Marker2D

@export var bombe_szene: PackedScene
var max_boss_leben: float = 0.0

var schwelle_75: bool = false
var schwelle_50: bool = false
var schwelle_25: bool = false

var boss_kampf_gestartet : bool = false


func _ready():
	$BossFlugzeug/Hurtbox.hurt.connect(_on_boss_hurt)
	helm.visible = false
	purpleheart.visible = false
	max_boss_leben = float(boss_leben)

func _process(_delta):
	if boss_kampf_gestartet:
		return
		
	var bodies = trigger_zone.get_overlapping_bodies()
	
	if bodies.size() > 0:
		for body in bodies:
			if body.is_in_group("player"):
				boss_kampf_gestartet = true
				start_boss_intro()
				break

func _physics_process(delta: float) -> void:
	if not boss_aktiv:
		return
		
	if ist_tot:
		if absturz_nach_links:
			boss_flugzeug.global_position.x -= geschwindigkeit * delta
		else:
			boss_flugzeug.global_position.x += geschwindigkeit * delta
			
		boss_flugzeug.global_position.y += geschwindigkeit * delta
		return

	if fliegt_nach_links:
		boss_flugzeug.global_position.x -= geschwindigkeit * delta
		boss_flugzeug.scale.x = 1.0
		if boss_flugzeug.global_position.x <= grenze_links:
			fliegt_nach_links = false
	else:
		boss_flugzeug.global_position.x += geschwindigkeit * delta
		boss_flugzeug.scale.x = -1.0
		if boss_flugzeug.global_position.x >= grenze_rechts:
			fliegt_nach_links = true

	if boss_aktiv and not ist_tot and kann_schiessen:
		schiesse_mg_salve()

func _pruefe_und_loesche_gegner(node: Node, x_links: float, x_rechts: float):
	for child in node.get_children():
		if "current_health" in child and child is CharacterBody2D:
			var g_x = child.global_position.x
			if g_x <= x_links + 30.0 and g_x >= x_links - 50.0:
				child.queue_free()
			elif g_x >= x_rechts - 30.0 and g_x <= x_rechts + 50.0:
				child.queue_free()
		
		if child.get_child_count() > 0:
			_pruefe_und_loesche_gegner(child, x_links, x_rechts)

func start_boss_intro():
	var spieler = get_tree().get_first_node_in_group("player")
	if spieler:
		var feste_ziel_x = 6750.0
		start_boss_flugzeug()
		
		spieler.global_position.x = feste_ziel_x
		
		if "velocity" in spieler:
			spieler.velocity = Vector2.ZERO
			
		if spieler.has_method("reset_physics_interpolation"):
			spieler.reset_physics_interpolation()

	animation_player.play("introCrash")
	await animation_player.animation_finished

func start_boss_flugzeug() -> void:
	boss_aktiv = true
	Tutorials.show_tutorial("first_boss")
	AudioManager.play("ww2_boss")
	boss_flugzeug.visible = true

func _on_boss_hurt(damage: int, _knockback: Vector2):
	if ist_tot:
		return
		
	_play_hurt_flash()
	boss_leben -= damage
	
	if max_boss_leben > 0.0:
		var aktuelle_prozent = (float(boss_leben) / max_boss_leben) * 100.0
		
		if aktuelle_prozent <= 75.0 and not schwelle_75:
			schwelle_75 = true
			starte_bombenregen(60)
		elif aktuelle_prozent <= 50.0 and not schwelle_50:
			schwelle_50 = true
			starte_bombenregen(60)
		elif aktuelle_prozent <= 25.0 and not schwelle_25:
			schwelle_25 = true
			starte_bombenregen(60)
	
	if boss_leben <= 0:
		boss_besiegt()

func starte_bombenregen(anzahl: int) -> void:
	if ist_tot:
		return
		
	for i in range(anzahl):
		if ist_tot:
			break
			
		var bombe_instanz = bombe_szene.instantiate()
		
		var rand_x = randf_range(6200.0 + 50.0, 8000.0 - 50.0)
		bombe_instanz.global_position = Vector2(rand_x, -500.0)
		
		get_tree().current_scene.add_child(bombe_instanz)
		
		await get_tree().create_timer(randf_range(0.05, 0.15)).timeout

func _play_hurt_flash() -> void:
	if flash_tween and flash_tween.is_valid():
		flash_tween.kill()
	
	var boss_sprite = $BossFlugzeug/AnimatedSprite2D
	
	boss_sprite.modulate = FLASH_COLOR
	
	flash_tween = create_tween()
	flash_tween.tween_interval(0.05)
	flash_tween.tween_property(boss_sprite, "modulate", ORIGINAL_MODULATE, 0.1)

func boss_besiegt():
	ist_tot = true
	SaveManager.collect_shard("boss_ww2", 5)
	absturz_nach_links = fliegt_nach_links
	
	if has_node("WrackLinks"):
		$WrackLinks.queue_free()
		
	if has_node("WrackRechts"):
		$WrackRechts.queue_free()
		
	await get_tree().create_timer(1.0).timeout
	
	boss_aktiv = false
	boss_wrack.visible = true
	helm.visible = true
	purpleheart.visible = true
	if has_node("BossFlugzeug"):
		$BossFlugzeug.queue_free()

func _on_schadens_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Gegner"):
		body.queue_free()

func schiesse_mg_salve() -> void:
	kann_schiessen = false
	
	for i in range(5):
		if ist_tot or not boss_aktiv:
			break
			
		var kugel_instanz = kugel_szene.instantiate()
		kugel_instanz.global_position = muendung.global_position
		
		if boss_flugzeug.scale.x < 0:
			kugel_instanz.direction = Vector2.RIGHT
		else:
			kugel_instanz.direction = Vector2.LEFT
			
		get_tree().current_scene.add_child(kugel_instanz)

		if muendung.has_node("MuendungsBlitz"):
			muendung.get_node("MuendungsBlitz").visible = true
			
		await get_tree().create_timer(0.05).timeout
		
		if muendung.has_node("MuendungsBlitz"):
			muendung.get_node("MuendungsBlitz").visible = false
		
		await get_tree().create_timer(0.10).timeout
	
	await get_tree().create_timer(2.0).timeout
	if boss_aktiv and not ist_tot:
		kann_schiessen = true

func _on_trigger_zone_body_entered():
	pass
