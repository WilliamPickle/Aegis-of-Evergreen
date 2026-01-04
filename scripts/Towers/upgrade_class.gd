extends UserInterface
class_name tower_upgrader

@export var tower : Tower


# type display vars
@onready var right_arrow : Button = $Control/Background/TypeDisplay/Right
@onready var left_arrow : Button = $Control/Background/TypeDisplay/Left
@onready var type_text : Label = $Control/Background/TypeDisplay/TypeText

var types = ["First", "Last", "Strong", "Weak"]
var cur_type : int = 0

func _ready() -> void:
	#print(tower.data_resource.object)
	right_arrow.pressed.connect(_update_type.bind(1))
	left_arrow.pressed.connect(_update_type.bind(-1))


func _update_type(value : int):
	cur_type = (cur_type + value) % 4
	type_text.text = types[cur_type]
	
