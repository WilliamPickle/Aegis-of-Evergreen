extends TextureRect
@onready var lvl_label: Label = $LvlLabel
@onready var xp_bar: TextureRect = $XpBar
var bar_length: float

func _ready() -> void:
	lvl_label.text = str(PlayerStats.PlayerLevel)
	
	# initialize xp bar length
	bar_length = xp_bar.texture.get_width() * xp_bar.scale.x
	xp_bar.scale.x = (float(PlayerStats.PlayerXp % 1000)) / PlayerStats.XpThreshold
	
	# hookup signals
	PlayerStats.player_level_changed.connect(update_level)
	PlayerStats.xp_changed.connect(update_xp_bar)
	
func update_level() -> void:
	lvl_label.text = str(PlayerStats.PlayerLevel)
	
func update_xp_bar() -> void:
	bar_length = xp_bar.texture.get_width() * xp_bar.scale.x
	xp_bar.scale.x = (float(PlayerStats.PlayerXp % 1000)) / PlayerStats.XpThreshold
