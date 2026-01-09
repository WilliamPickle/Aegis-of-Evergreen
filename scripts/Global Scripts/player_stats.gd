extends Node
signal xp_changed
signal player_level_changed

var PlayerXp: int = 0
var XpThreshold: int = 1000
var PlayerLevel: int = 1
var PrevLevel: int = 0

func _ready() -> void:
	xp_changed.connect(calculate_player_lvl)
	
func calculate_player_lvl():
	PlayerLevel = floori(PlayerXp / XpThreshold) + 1
	if PlayerLevel != PrevLevel:
		emit_signal("player_level_changed")
	PrevLevel = PlayerLevel
