extends Node2D


const HOLD_THRESHOLD := 0.5
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var hold_start := 0.0
var is_holding := false
var hold_completed := false
var current:= 0

const COLA = preload("res://inventory/items/beverage/cola.tres")
const PENNER = preload("res://inventory/items/beverage/penner.tres")
const REDBULL = preload("res://inventory/items/beverage/redbull.tres")
const SPEZI = preload("res://inventory/items/beverage/spezi.tres")
const WHITEMONSTER = preload("res://inventory/items/beverage/whitemonster.tres")
const WATER = preload("res://inventory/items/beverage/water.tres")

var items = [WATER,COLA,SPEZI,REDBULL,WHITEMONSTER,PENNER]
var price = [10, 10, 15 , 20, 25, 50]


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		hold_start = Time.get_ticks_msec() / 1000.0
		is_holding = true
		hold_completed = false

	if is_holding and Input.is_action_pressed("interact"):
		if (Time.get_ticks_msec() / 1000.0) - hold_start >= HOLD_THRESHOLD:
			_kaufen()
			hold_completed = true
			is_holding = false

	if Input.is_action_just_released("interact"):
		if is_holding and not hold_completed:
			_scrollen()
		is_holding = false


func _scrollen() -> void:
	if current >= 6:
		current = 0
		sprite.play(str(current))
		return
	current += 1
	sprite.play(str(current))
	return
	

func _kaufen() -> void:
	var ok = SaveManager.buy(price[current -1])
	if ok:
		SaveManager.add_item(items[current -1],1)
