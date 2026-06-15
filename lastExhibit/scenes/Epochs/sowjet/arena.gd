extends Area2D

@export var tuer1 : Node2D
@export var tuer2 : Node2D
@export var boss_scene : PackedScene
var boss_spawned : bool = false

func _ready() -> void:
	tuer1 = get_node("/root/SovietUnion/Bossraum/Tuer1")
	tuer2 = get_node("/root/SovietUnion/Bossraum/Tuer2")
	tuer1.open()
	tuer2.open()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		tuer1.close()
		tuer2.close()
		if not boss_spawned:
			boss_spawned = true
			var boss = boss_scene.instantiate()
			get_parent().add_child(boss)
			boss.global_position = Vector2(-300,735)
