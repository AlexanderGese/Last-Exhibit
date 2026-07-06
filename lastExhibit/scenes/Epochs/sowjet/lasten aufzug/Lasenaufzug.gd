extends Area2D

@export var floor_name: String = ""
@export var player: Node

var player_collided: bool = false
var aufzug: int = 0 
var aufzugziel: int = 1
var floor := 0

const FLOOR_PX := {
0: 1,     # ground
1: 385,   # first
2: 769,    # second
3: 1153,   # third
4: 1537    # fourth
}



func _ready() -> void:
	add_to_group("lastenaufzug")

#ruft den Aufzug falls auf anderer Ebene
func aufzug_aktivieren(level: int) -> void:
	if level == floor:
		return
	floor = level
	aufzugziel = FLOOR_PX.get(floor, 0)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_collided = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_collided = false

func _process(_delta: float) -> void:
	#bewegt den Aufzug in Schritten bis zumZiel
	if aufzug < aufzugziel:
		aufzug = aufzug +2
		move_local_y(2)
		if player_collided:
			player.global_position += Vector2(0, 2)
	
	if aufzug > aufzugziel:
		aufzug = aufzug -2
		move_local_y(-2)
		if player_collided:
			player.global_position += Vector2(0, -2)
	
	#setzt das neue Aufzgsziel
	if player_collided and Input.is_action_just_pressed("up") and floor>0:
		floor=floor-1
		aufzugziel= FLOOR_PX.get(floor, 0) 
	
	if player_collided and Input.is_action_just_pressed("down") and floor<4:
		floor=floor+1
		aufzugziel= FLOOR_PX.get(floor, 0) 
