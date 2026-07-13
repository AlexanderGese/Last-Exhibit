extends CharacterBody2D

@export var walk_speed   : float = 180.0
@export var run_speed    : float = 280.0
@export var gravity      : float = 980.0
@export var min_x        : float = 4160.0
@export var max_x        : float = 4830.0
@export var kampf_dist   : float = 50.0
@export var run_distanz  : float = 100.0
@export var hit_cooldown : float = 3.0
@export var hit_distanz  : float = 70.0
@export var max_hp : int = 400

@export var dash_speed     : float = 450.0
@export var dash_strecke_max : float = 100.0
@export var dash_damage    : int = 20

var dash_timer    : float = 0.0
var is_dashing    : bool  = false
var dash_richtung : float = 0.0
var dash_distanz_verbleibend : float = 0.0

var hp : int = max_hp
var hat_verloren : bool = false
var is_dead : bool = false
var flash_tween: Tween = null
@export var knockback_resistance : float = 0.7   
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const ORIGINAL_MODULATE := Color.WHITE
const FLASH_COLOR := Color(2.5, 0.3, 0.3, 1)

@onready var sprite_root = $SpriteRoot
@onready var schwert: ItemPickup = $Schwert
@onready var helm: ItemPickup = $Ritterhelm

var hit_timer    : float = 0.0
var is_attacking : bool  = false
var hat_getroffen : bool = false
var player : CharacterBody2D
var facing_right : bool = true

#wirt am anfang ausgeführt
func _ready() -> void:
	await get_tree().process_frame
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	$Hitbox.monitoring = false
	$Hitbox.area_entered.connect(_on_hitbox_area_entered)
	$Hurtbox.hurt.connect(_on_hurt)
	$Hitbox2.monitoring = false
	$Hitbox2/CollisionShape2D.disabled = true
	$Hitbox2.area_entered.connect(_on_hitbox_2_area_entered)
	helm.visible = false
	schwert.visible = false


func setup(x: float, y: float) -> void:
	global_position = Vector2(x, y)

#wird in regelmaessigen intervallen aufgerufen und steuert den Boss
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if player == null:
		return
	hit_timer -= delta
	var dist_x = abs(global_position.x - player.global_position.x)
	if is_attacking:
		velocity.x = 0.0
	elif dist_x <= hit_distanz and hit_timer <= 0.0:
		hit_start()
	else:
		_move_towards_player()
	
	if is_dashing:
		dash_update(delta)
	update_facing()
	move_and_slide()

#beginn des angriffes, bei dem der gegner durch eine durchsprintet
func dash_start() -> void:
	
	is_attacking  = true
	is_dashing    = true
	hat_getroffen = false
	dash_richtung = 1.0 if facing_right else -1.0
	dash_distanz_verbleibend = dash_strecke_max
	if is_dead:
		dash_ende()
		return
	$AnimatedSprite2D.play("stab_start")
	$Hitbox2.set_deferred("monitoring", true)
	$Hitbox2/CollisionShape2D.set_deferred("disabled", false)
	await $AnimatedSprite2D.animation_finished
	if is_dead:
		return
	$AnimatedSprite2D.play("stab_middle")

# fortführen dieser attacke, das wird regelmaessig ausgeführt
func dash_update(delta: float) -> void:
	if is_dead:
		dash_ende()
		return
	$AnimatedSprite2D.play("stab_middle")
	velocity.x = dash_richtung * dash_speed
	dash_distanz_verbleibend -= abs(velocity.x) * delta
	if not hat_getroffen:
		for area in $Hitbox2.get_overlapping_areas():
			_on_hitbox_2_area_entered(area)
	if dash_distanz_verbleibend <= 0.0:
		dash_ende()

#Ende des Angriffes
func dash_ende() -> void:
	is_dashing   = false
	is_attacking = false
	velocity.x   = 0.0
	$Hitbox2.set_deferred("monitoring", false)
	$Hitbox2/CollisionShape2D.set_deferred("disabled", true)
	if is_dead:
		dash_ende()
		return
	$AnimatedSprite2D.play("stab_end")
	await $AnimatedSprite2D.animation_finished
	if not is_dead:
		$AnimatedSprite2D.play("idle")

#Beginn des Angriffes, waehlt zwischen verschiedenen
func hit_start() -> void:
	Tutorials.show_tutorial("first_boss")
	AudioManager.play("medieval_boss")
	is_attacking  = true
	hat_getroffen = false
	hit_timer     = hit_cooldown
	velocity.x    = 0.0
	var anim : String
	if randf() < 0.7:
		if randf() < 0.35:
			anim = "attack1"
		else:
			anim = "attack2"
		$AnimatedSprite2D.play(anim)
	else:
		dash_start()
		return

	await get_tree().create_timer(0.6).timeout
	if is_dead:
		return
	$Hitbox.set_deferred("monitoring", true)
	$Hitbox/CollisionShape2D.set_deferred("disabled", false)
	await get_tree().create_timer(0.2).timeout
	if is_dead:
		return
	$Hitbox.set_deferred("monitoring", false)
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.play("idle")
	is_attacking = false

func _on_hitbox_area_entered(area: Area2D) -> void:
	if hat_getroffen:
		return
	if area is Hurtbox:
		hat_getroffen = true
		$Hitbox.set_deferred("monitoring", false)
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)

func _on_hitbox_2_area_entered(area: Area2D) -> void:
	if hat_getroffen:
		return
	if area is Hurtbox:
		hat_getroffen = true
		$Hitbox2.set_deferred("monitoring", false)
		$Hitbox2/CollisionShape2D.set_deferred("disabled", true)

#Boss läuft zum Spieler, schneller wenn die Distanz groesser ist
func _move_towards_player() -> void:
	var dist = global_position.distance_to(player.global_position)
	var dir  = sign(player.global_position.x - global_position.x)
	if global_position.x <= min_x and dir < 0:
		velocity.x = 0.0
		return
	if global_position.x >= max_x and dir > 0:
		velocity.x = 0.0
		return
	if dist <= kampf_dist:
		velocity.x = move_toward(velocity.x, 0.0, 20.0)
		$AnimatedSprite2D.play("idle")
		return
	if dist > run_distanz:
		velocity.x = dir * run_speed
		$AnimatedSprite2D.play("run")
	else:
		velocity.x = dir * walk_speed
		$AnimatedSprite2D.play("walk")

# erneuert und ueberprueft, ob der Boss noch in die richtige Richtung schaut
func update_facing() -> void:
	if velocity.x > 5.0:
		facing_right = true
	elif velocity.x < -5.0:
		facing_right = false
	else:
		facing_right = player.global_position.x > global_position.x
	$AnimatedSprite2D.flip_h = not facing_right
	$AnimatedSprite2D.position.x = 30.0 if facing_right else -30.0

#Funktion der hurtbox, wird ausgelöst,wenn der Boss Schaden bekommt
func _on_hurt(damage: int, knockback: Vector2) -> void:
	if is_dead:
		return
	
	hp -= damage
	velocity += knockback * (1.0 - knockback_resistance)
	
	_play_hurt_flash()
	
	if hp <= 0:
		Events.sw_boss_dead.emit()
		die()


func _play_hurt_flash() -> void:
	if flash_tween and flash_tween.is_valid():
		flash_tween.kill()
	
	sprite.modulate = FLASH_COLOR
	flash_tween = create_tween()
	flash_tween.tween_interval(0.1)
	flash_tween.tween_property(sprite, "modulate", ORIGINAL_MODULATE, 0.2)

#beendete alle wichtigen Prozesse und Animationen, bevor das Objekt geloescht wird
func die() -> void:
	is_dead = true
	SaveManager.collect_shard("boss_mittelalter", 5)
	$AnimatedSprite2D.play("death")
	set_physics_process(false)
	is_attacking = false
	helm.visible = true
	schwert.visible = true
	$Hitbox.queue_free()
	$Hitbox2.queue_free()
	$Hurtbox.queue_free()
	var gate1 = get_node("../Doors/Gate1")
	gate1.open()
	var gate2 = get_node("../Doors/Gate2")
	gate2.open()
