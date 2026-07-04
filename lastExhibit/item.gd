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

@export_group("Armor")
# Fraction of incoming damage this piece blocks (0.15 = -15%). Summed across all
# equipped armor pieces, then capped, in Player.take_damage().
@export_range(0.0, 1.0, 0.01) var resistance: float = 0.0

@export_group("Consumable")
@export var heal_amount: float = 0.0

@export_group("Artifact")
@export var big_artifact: bool #true = big, false = small
@export var origin: String
