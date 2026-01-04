extends Sprite2D


# USE THIS IF FOLDER_PATH METHOD DOESNT WORK IN THE LONG RUN
#const test = {
	#"chipmunk_1" : preload("res://assets/sprites/towers/tower mugshots/chipmunk_1.png")
	#}
	
const folder_path : String = "res://assets/sprites/towers/tower mugshots/"
	
@onready var tower_image = $TowerImageBackground/TowerImage
@onready var stats_text = $Stats/StatsText
@onready var cost_text = $UpgradeCost
@onready var sell_text = $SellCost


func _ready() -> void:
	update_data("chipmunk_3", 0.33)
	
func update_data(img_file : String, cost : float):
	var file = img_file+".png"
	tower_image.texture = load(folder_path + file)
	cost_text.text = str(cost)
	
	var sell_cost : float = cost * 0.75
	sell_text.text = str(round(sell_cost * 100)/100)
