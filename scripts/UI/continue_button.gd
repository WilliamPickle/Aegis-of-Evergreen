extends Icon

static var cur_cutscene_index: int = 0
const levels_list = [
	"res://scenes/level_1.tscn", 
	"res://scenes/level_2.tscn", 
	"res://scenes/level_3.tscn", 
	"res://scenes/map_2_level_1.tscn", 
	"res://scenes/map_2_level_2.tscn", 
	"res://scenes/map_2_level_3.tscn",
	"res://scenes/map_3_level_1.tscn",
	]
const cutscene_list = ["res://scenes/cutscene2.tscn"]

func _ready() -> void:
	super._ready()
	print("lvls beaten: ", PlayerStats.lvls_beaten)
	print("file path: ", levels_list[PlayerStats.lvls_beaten])
	#the second half of the if statement is for the tutorial
	if PlayerStats.lvls_beaten % 3 == 0 and PlayerStats.lvls_beaten != 0:
		file_path = cutscene_list[cur_cutscene_index]
		cur_cutscene_index += 1
	else:
		file_path = levels_list[PlayerStats.lvls_beaten]
