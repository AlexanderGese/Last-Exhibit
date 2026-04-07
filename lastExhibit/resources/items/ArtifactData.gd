# res://resources/items/ItemData.gd
class_name ItemData
extends Resource

@export var id: String = ""
@export var display_name: String = ""
@export var icon: Texture2D = null
@export var category: String = "normal"
@export var equip_slot: String = ""  # "waffe", "helm", "oberteil", "hose", "schmuck" , "artifakt" oder ""
