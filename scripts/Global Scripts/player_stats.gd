extends Node
signal xp_changed
signal money_changed
signal player_level_changed

# Player Vars
var PlayerXp: int = 0
var XpThreshold: int = 1000
var PlayerLevel: int = 1
var PrevLevel: int = 0
var lvls_beaten = 0

# Money Vars
const DEFAULT_MONEY : Array = [
	[50.0, 100.0, 200.0],
	[500.0, 600.0, 700.0],
	[800.0, 900.0, 1000.0],
]
@onready var cur_money = DEFAULT_MONEY[0][2]

func _ready() -> void:
	xp_changed.connect(calculate_player_lvl)
	
func calculate_player_lvl():
	PlayerLevel = floori(PlayerXp / XpThreshold) + 1
	if PlayerLevel != PrevLevel:
		emit_signal("player_level_changed")
	PrevLevel = PlayerLevel

func purchase_item(item_amount : float) -> bool:
	print("This function was called!!!!")
	if cur_money >= item_amount:
		cur_money -= item_amount
		emit_signal("money_changed")
		return true

	return false
