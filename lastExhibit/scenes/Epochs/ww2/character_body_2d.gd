extends CharacterBody2D

# Variablen für die Bewegung
@export var speed: float = 100.0
@export var gravity: float = 980.0
@export var is_dead: bool = false

# Referenzen auf Nodes
@onready var animated_sprite = $AnimatedSprite2D # Passe den Namen an, falls er anders heißt

var player: Node2D = null

func _ready():
	# Sucht nach dem Spieler in der Gruppe "player"
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _physics_process(delta):
	# Schwerkraft hinzufügen, falls er in der Luft ist
	if not is_on_floor():
		velocity.y += gravity * delta

	# Wenn der Spieler existiert, bewege dich auf ihn zu
	if player and not is_dead: # 'is_dead' bauen wir später ein
		move_towards_player()
	else:
		velocity.x = 0
		animated_sprite.play("idle")

	move_and_slide()

func move_towards_player():
	# Richtung zum Spieler berechnen (-1 für links, 1 für rechts)
	var direction = sign(player.global_position.x - global_position.x)
	
	if direction != 0:
		velocity.x = direction * speed
		animated_sprite.play("run")
		
		# Sprite in die richtige Richtung spiegeln
		animated_sprite.flip_h = (direction < 0)
	else:
		velocity.x = 0
		animated_sprite.play("idle")
