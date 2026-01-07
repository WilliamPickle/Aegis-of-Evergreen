extends UserInterface
class_name tower_upgrader

const f_path : String = "res://assets/sprites/towers/tower mugshots/"
@export var tower : Tower
@export_enum("chipmunk","bee","flytrap") var tower_name : String 

# tower image vars
@onready var tower_image : TextureRect = $Control/Background/TowerImageBackground/TowerImage

# type display vars
@onready var right_arrow : Button = $Control/Background/TypeDisplay/Right
@onready var left_arrow : Button = $Control/Background/TypeDisplay/Left
@onready var type_text : Label = $Control/Background/TypeDisplay/TypeText

# cost vars
var cost : float = 10.0
@onready var costText : Label = $Control/Background/UpgradeCost
@onready var sellText : Label = $Control/Background/SellCost

var types = ["First", "Last", "Strong", "Weak"]
var cur_type : int = 0

func _ready() -> void:
	print(tower_name)
	tower_image.texture = load(f_path + str(tower_name)+"_1.png")
	#print(tower.data_resource.object)
	right_arrow.pressed.connect(_update_type.bind(1))
	left_arrow.pressed.connect(_update_type.bind(-1))


func _update_type(value : int):
	cur_type = (cur_type + value) % 4
	type_text.text = types[cur_type]
