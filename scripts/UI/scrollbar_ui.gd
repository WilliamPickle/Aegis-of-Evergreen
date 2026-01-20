extends UserInterface

# placement mask is the collision area where towers can't be placed on
@export var placement_mask : Area2D
@export var card_type : Array[String] = []
@export var scroll_container: HBoxContainer

# Text vars
@onready var game_data = JSON.parse_string(FileAccess.get_file_as_string("res://Game Data.json"))
const normal_color = Color(0,0,0,0)
const hover_color = Color(1,1,1,1)

# add any tower card here
const cards : Dictionary = { 
	"ranger" = preload("res://assets/sprites/towers/tower cards/ranger_card.png"),
	"chipmunk" = preload("res://assets/sprites/towers/tower cards/chipmunk_card.png"),
	"bee" = preload("res://assets/sprites/towers/tower cards/bee_card.png"),
	"flytrap" = preload("res://assets/sprites/towers/tower cards/fly_trap_card.png"),
}
func _ready() -> void:
	super._ready()
	var class_type = "tower"
	var font = "res://assets/fonts/quaver.ttf"
	var defualt_color = Color(1,1,1,0)
	#new_card.text = 
	
	for tower in card_type:
		# this is just to style the card pretty much
		# and to add it to the bar
		if tower == "ranger":
			class_type = "hero"
		else:
			class_type = "tower"
		var card_image = StyleBoxTexture.new()
		card_image.texture = cards[tower]
		var dark_card_image = StyleBoxTexture.new()
		dark_card_image.texture = cards[tower]
		dark_card_image.modulate_color = Color(0.5, 0.5, 0.5)
		
		var new_card = Tower_Placement.new()
		scroll_container.add_child(new_card)
		new_card.tower_type = tower
		new_card.map_area = placement_mask
		new_card.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		new_card.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		new_card.custom_minimum_size = Vector2(75, 100)
		
		new_card.focus_mode = Control.FOCUS_NONE
		new_card.add_theme_stylebox_override("normal", card_image)
		new_card.add_theme_stylebox_override("hover", dark_card_image)
		new_card.add_theme_stylebox_override("pressed", dark_card_image)
		new_card.add_theme_stylebox_override("hover_pressed", dark_card_image)
		
		
		new_card.text = "$"+str(int(game_data[class_type][tower]["cost"][0]))
		new_card.add_theme_font_override("font", load(font))
		new_card.add_theme_font_size_override("font_size", 24)
		new_card.add_theme_color_override("font_color", normal_color)
		new_card.add_theme_color_override("font_hover_color", hover_color)
		new_card.add_theme_color_override("font_hover_pressed_color", hover_color)
