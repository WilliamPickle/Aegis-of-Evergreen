extends UserInterface
class_name towerUpgrader

const f_path : String = "res://assets/sprites/towers/tower mugshots/"
@export var tower : Tower
@export var tower_name : String
## Put all description labels under this node
@export_enum("attacker","ranger") var type : String
@export var level_descriptions : Control
@export var tower_max_level : int = 3
@onready var cur_description : Label = level_descriptions.get_child(tower.level)

static var Game_Data = JSON.parse_string(FileAccess.get_file_as_string("res://Game Data.json"))["tower"]
@onready var tower_data = Game_Data[tower_name]
const tower_stats : Dictionary = {
	"attacker" = ["damage", "range", "attack_speed"],
	"ranger" = ["range"]
	#"melee" = ["damage", "range", "attack_speed"]
}

# stats
@export var is_attacker : bool = false
#@export var stats : Dictionary[String, bool]
@onready var level = tower.level
@onready var stats : Dictionary[String, Button] = {
	"damage" : $Control/Background/StatsDisplay/StatsContainer/Damage,
	"range" : $Control/Background/StatsDisplay/StatsContainer/Range,
	"attack_speed" : $Control/Background/StatsDisplay/StatsContainer/AttackSpeed,
	#"Damage" : $Control/Background/StatsDisplay/StatsContainer,
	#"Damage" : $Control/Background/StatsDisplay/StatsContainer,
}
const text_path := "ScrollContainer/VBoxContainer/Label"

# tower image vars
@onready var tower_image : TextureRect = $Control/Background/TowerImageBackground/TowerImage

# type display vars
@onready var right_arrow : Button = $Control/Background/TypeDisplay/Right
@onready var left_arrow : Button = $Control/Background/TypeDisplay/Left
@onready var type_text : Label = $Control/Background/TypeDisplay/TypeText

# cost vars
@onready var costText : Label = $Control/Background/UpgradeCost
@onready var sellText : Label = $Control/Background/SellCost

# sell and upgrade bottons
@onready var upgrade_button = $Control/Background/UpgradeButton
@onready var sell_button = $Control/Background/SellButton

var types = ["First", "Last", "Strong", "Weak"]
var cur_type : int = 0

func _ready() -> void:
	super._ready()
	await tower.tower_placed
	if tower.global_position.x > 0:
		offset = Vector2(-910,0)
	for stat in tower_stats[type]:
		var button : Button = stats[stat]
		button.visible = true
		button.get_node(text_path).text = str(tower_data[stat][0])
	tower_image.texture = load(f_path + str(tower_name)+"1.png")
	
	right_arrow.pressed.connect(_update_type.bind(1))
	left_arrow.pressed.connect(_update_type.bind(-1))

	costText.text = str(tower.cost)
	sellText.text = str(tower.sell_value)
	cur_description.visible = true
	upgrade_button.button_down.connect(upgrade_tower)
	sell_button.button_down.connect(_sell_tower)

func _update_type(value : int):
	cur_type = (cur_type + value) % 4
	if cur_type == -1:
		cur_type = 3
	type_text.text = types[cur_type]
	
	tower.target_type = cur_type

func upgrade_tower():
	if tower.level < 2 and PlayerStats.purchase_item(tower.cost):
		tower_image.texture = load(f_path + tower_name + str(tower.level+2) + ".png")
		tower.upgrade_tower()
		sellText.text = str(tower.sell_value)
		cur_description.visible = false
		cur_description = level_descriptions.get_child(tower.level)
		cur_description.visible = true
		for stat in tower_stats[type]:
			var button : Button = stats[stat]
			button.visible = true
			button.get_node(text_path).text = str(tower_data[stat][tower.level])
	if tower.level == tower_max_level - 1:
		costText.text = "Maxed Out"
	else:
		costText.text = str(tower.cost)

func _sell_tower():
	ControlHandler.current_states.erase(ControlHandler.ControlState.VIEWING_TOWER)
	PlayerStats.cur_money += tower.sell_value
	PlayerStats.emit_signal("money_changed")
	if tower.is_hero:
		tower.does_exist = false
	#if tower is Ranger:
		#tower.does_exist = false
	#elif tower is Druid:
		#tower.does_exist = false
	tower.current_tower = null
	tower.queue_free()
	
func _update_text():
	pass
