extends Node2D
signal xp_changed
signal money_changed
signal player_level_changed

# Signals for other scripts aside from tower to know when an action occured
signal gtower_placed(tower : Tower)
signal upgraded_tower(tower : Tower)

# Player Vars
const StartingPlayerLevel: int = 12
const XpThreshold: int = 1000
var PlayerXp: int = 0
var PlayerLevel: int = StartingPlayerLevel
var PrevLevel: int = StartingPlayerLevel
# It's negative one because of the tutorial
var lvls_beaten = -1

# Money Vars
const DEFAULT_MONEY : Array = [
	[50.0, 100.0, 150.0],
	[150.0, 200.0, 250.0],
	[250.0, 350.0, 500.0],
	[250.0, 350.0, 500.0],
]
@onready var cur_money = DEFAULT_MONEY[2][2]
@onready var total_money_gained = cur_money
var pity_money = 0

static var can_draw := false
static var map_shapes : Array[PackedVector2Array]
static var prev_map : Node2D

func _ready() -> void:
	z_index = 11
	#process_mode = Node.PROCESS_MODE_ALWAYS
	xp_changed.connect(calculate_player_lvl)
	
func _draw() -> void:
	print("THIS IS CAN DRAW: ", can_draw, " AND THIS IS LIST: ", map_shapes)
	if can_draw:
		for i in len(map_shapes):
			draw_polygon(map_shapes[i], [Color(1,0,0,0.1)])
	
	
func calculate_player_lvl():
	PlayerLevel = floori(PlayerXp / XpThreshold) + StartingPlayerLevel
	if PlayerLevel != PrevLevel:
		emit_signal("player_level_changed")
	PrevLevel = PlayerLevel

func purchase_item(item_amount : float) -> bool:
	#print("This function was called!!!!")
	if cur_money >= item_amount:
		cur_money -= item_amount
		emit_signal("money_changed")
		return true

	return false

func display_map_collision(display := can_draw, new_scene := true) -> void:
	can_draw = display
	map_shapes.clear()
	queue_redraw()
	
	if new_scene and is_instance_valid(prev_map):
		await prev_map.tree_exited
	var _map_shapes = get_tree().get_nodes_in_group("map_collision")
	var _map := get_tree().get_nodes_in_group("map_node")
	#if len(_map) > 0:

	if len(_map) > 0:
		prev_map = _map[0]
		for shape : CollisionPolygon2D in _map_shapes:
			if is_instance_valid(shape):
				map_shapes.append(shape.polygon)
		queue_redraw()
	
