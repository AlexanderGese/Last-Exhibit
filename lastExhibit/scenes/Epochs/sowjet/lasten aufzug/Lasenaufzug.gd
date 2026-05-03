extends Area2D

@export var floor_name: String = ""
var player_collided: bool = false
var aufzug: int = 0 
var aufzugziel: int = 0
const FLOOR_PX := {
0: 0,     # ground
1: 384,   # first
2: 768,    # second
3: 1152,   # third
4: 1536    # fourth
}

var floor := 0


func _ready() -> void:
	add_to_group("lastenaufzug")
	

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
	if aufzug < aufzugziel:
		aufzug = aufzug +2
		move_local_y(2)
	if aufzug > aufzugziel:
		aufzug = aufzug -2
		move_local_y(-2)
	
	if player_collided and Input.is_action_just_pressed("up") and floor>0:
		floor=floor-1
		aufzugziel= FLOOR_PX.get(floor, 0) 
		
	if player_collided and Input.is_action_just_pressed("down") and floor<4:
		floor=floor+1
		aufzugziel= FLOOR_PX.get(floor, 0) 
		
