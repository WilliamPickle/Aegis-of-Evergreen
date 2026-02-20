extends Node
signal xp_changed
signal money_changed
signal player_level_changed
#signal upgraded_tower

# Player Vars
const StartingPlayerLevel: int = 3
const XpThreshold: int = 1000
var PlayerXp: int = 0
var PlayerLevel: int = StartingPlayerLevel
var PrevLevel: int = StartingPlayerLevel
# It's negative one because of the tutorial
var lvls_beaten = -1

# Money Vars
const DEFAULT_MONEY : Array = [
	[50.0, 100.0, 150.0],
	[150.0, 250.0, 700.0],
	[800.0, 900.0, 1000.0],
]
@onready var cur_money = DEFAULT_MONEY[0][1]
@onready var total_money_gained = cur_money
var pity_money = 0

func _ready() -> void:
	xp_changed.connect(calculate_player_lvl)
	
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
