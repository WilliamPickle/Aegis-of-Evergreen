extends Icon

const levels_list = ["res://scenes/level_1.tscn", "res://scenes/level_2.tscn", "res://scenes/level_3.tscn"]

func _ready() -> void:
	super._ready()
	#print("lvls beaten: ", PlayerStats.lvls_beaten)
	#print("file path: ", levels_list[PlayerStats.lvls_beaten])
	file_path = levels_list[PlayerStats.lvls_beaten]
