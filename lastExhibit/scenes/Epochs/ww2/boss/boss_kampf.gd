extends Node2D

@onready var trigger_zone = $TriggerZone
@onready var animation_player = $AnimationPlayer

var boss_leben : int = 100
@onready var boss_flugzeug = $BossFlugzeug
var boss_aktiv : bool = false

const FLASH_COLOR := Color(2.5, 0.3, 0.3, 1)
const ORIGINAL_MODULATE := Color.WHITE
var flash_tween: Tween = null
@onready var boss_wrack: Sprite2D = $BossWrack
@export var geschwindigkeit: float = 200.0
@export var grenze_links: float = 6200.0
@export var grenze_rechts: float = 8000.0
var ist_tot: bool = false

var fliegt_nach_links: bool = true
var absturz_nach_links: bool = true

@export var kugel_szene: PackedScene = preload("res://scenes/Epochs/ww2/boss/USBullet.tscn")
@export var schuss_cooldown: float = 1.0
var kann_schiessen: bool = true
@onready var muendung = $BossFlugzeug/Marker2D

var boss_kampf_gestartet : bool = false


func _ready():
	$BossFlugzeug/Hurtbox.hurt.connect(_on_boss_hurt)

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
		var wand_links_x = $WrackLinks/CollisionShape2D.global_position.x
		var wand_rechts_x = $WrackRechts/CollisionShape2D.global_position.x
		var sicherheits_abstand = 120.0
		start_boss_flugzeug()
		
		if abs(spieler.global_position.x - wand_links_x) < abs(spieler.global_position.x - wand_rechts_x):
			spieler.global_position.x = wand_links_x + sicherheits_abstand
		else:
			spieler.global_position.x = wand_rechts_x - sicherheits_abstand
			
		if spieler.has_method("reset_physics_interpolation"):
			spieler.reset_physics_interpolation()

	animation_player.play("introCrash")
	await animation_player.animation_finished

func start_boss_flugzeug() -> void:
	boss_aktiv = true
	boss_flugzeug.visible = true

func _on_boss_hurt(damage: int, _knockback: Vector2):
	if ist_tot:
		return
		
	_play_hurt_flash()
	boss_leben -= damage
	
	if boss_leben <= 0:
		boss_besiegt()

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
	absturz_nach_links = fliegt_nach_links
	
	if has_node("WrackLinks"):
		$WrackLinks.queue_free()
		
	if has_node("WrackRechts"):
		$WrackRechts.queue_free()
		
	await get_tree().create_timer(1.0).timeout
	
	boss_aktiv = false
	boss_wrack.visible = true
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
