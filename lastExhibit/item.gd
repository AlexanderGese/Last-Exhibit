class_name Item
extends Resource

enum Type { ARTIFACT, WEAPON, HEAD, BODY, LEGS, FEET, CONSUMABLE, AMMO, KEY, CURRENCY, TOOL, DOCUMENT }

@export var id: String
@export var name: String
@export var icon: Texture2D
@export var type: Type
@export var stackable: bool = false
@export var max_stack: int = 1
@export var value: int = 0

@export_group("Consumable")
@export var heal_amount: float = 0.0
