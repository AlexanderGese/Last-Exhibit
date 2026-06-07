extends TextureRect

@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var label: Label = $VBoxContainer/Label
@onready var label_2: Label = $VBoxContainer/Label2
@onready var label_3: Label = $VBoxContainer/Label3
@onready var label_4: Label = $VBoxContainer/Label4
@onready var label_5: Label = $VBoxContainer/Label5
@onready var label_6: Label = $VBoxContainer/Label6
@onready var label_7: Label = $VBoxContainer/Label7
@onready var label_8: Label = $VBoxContainer/Label8
@onready var label_9: Label = $VBoxContainer/Label9

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var messages = SaveManager.player.messages
	label.text = messages[8]
	label_2.text = messages[7]
	label_3.text = messages[6]
	label_4.text = messages[5]
	label_5.text = messages[4]
	label_6.text = messages[3]
	label_7.text = messages[2]
	label_8.text = messages[1]
	label_9.text = messages[0]
