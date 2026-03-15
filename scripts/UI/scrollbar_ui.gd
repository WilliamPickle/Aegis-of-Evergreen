extends UserInterface

# placement mask is the collision area where towers can't be placed on
@export var placement_mask : Area2D
## this is to manually add in cards. Every card is already unlocked
## automatically through the script based on player level, including our starter towers.
## use this for debugging, like if you want to add a god tower, then remove it from the list.
@export var card_type : Array[String] = []
@export var scroll_container: HBoxContainer

# Text vars
const font := "res://assets/fonts/quaver.ttf"
const normal_color = Color(0,0,0,0)
const hover_color = Color(1,1,1,1)
@onready var game_data = JSON.parse_string(FileAccess.get_file_as_string("res://Game Data.json"))

# guidebook popup vars
var guidebook_popup := preload("res://scenes/UI/guidebook_popup.tscn")

const ally_guidebook_pgs : Dictionary = {
	"ranger" : 1,
	"chipmunk" : 2,
	"bee" : 2,
	"flytrap" : 3,
	"druid" : 1,
}

# add any tower card here
const cards : Dictionary = { 
	"ranger" = preload("res://assets/sprites/towers/tower cards/ranger_card_2.png"),
	"druid" = preload("res://assets/sprites/towers/tower cards/druid_card.png"),
	"chipmunk" = preload("res://assets/sprites/towers/tower cards/chipmunk_card.png"),
	"bee" = preload("res://assets/sprites/towers/tower cards/bee_card.png"),
	"flytrap" = preload("res://assets/sprites/towers/tower cards/fly_trap_card.png"),
	"flower" = preload("res://assets/sprites/towers/tower cards/rhododendron_card.png"),
	"rabbit" = preload("res://assets/sprites/towers/tower cards/rabbit_card.png"),
	"god" = preload("res://assets/sprites/towers/tower cards/base_tower_card.png"),
}

# card unlocks based on level
const unlockable_allies : Dictionary = { 
	"0" : "chipmunk",
	"1" : "ranger",
	"2" : "bee",
	"3" : "flytrap",
	"5" : "druid",
	"9" : "rabbit",
}

# the vars pro jellyfish added into the ready function but I made them global
#@onready var font = "res://assets/fonts/quaver.ttf"
#@onready var defualt_color = Color(1,1,1,0)
	
func _ready() -> void:
	super._ready()
	#new_card.text = 
	PlayerStats.player_level_changed.connect(unlock_new_ally)
	
	# adding in the manually added cards from the export variable
	for tower in card_type:
		# this is just to style the card pretty much
		# and to add it to the bar
		add_card(tower)
		
	# adding in the unlocked cards
	for i in range(PlayerStats.PlayerLevel + 1):
		if str(i) not in unlockable_allies:
			continue
		add_card(unlockable_allies[str(i)])
		
		
func unlock_new_ally():
	if str(PlayerStats.PlayerLevel) not in unlockable_allies:
		return
	else:
		add_card(unlockable_allies[str(PlayerStats.PlayerLevel)])
		show_guidebook_popup(unlockable_allies[str(PlayerStats.PlayerLevel)])
	
	
func add_card(tower):
	# this is just to style the card pretty much
	# and to add it to the bar
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
	
	
	new_card.text = "$"+str(int(game_data["tower"][tower]["cost"][0]))
	new_card.add_theme_font_override("font", load(font))
	new_card.add_theme_font_size_override("font_size", 24)
	new_card.add_theme_color_override("font_color", normal_color)
	new_card.add_theme_color_override("font_hover_color", hover_color)
	new_card.add_theme_color_override("font_hover_pressed_color", hover_color)


func show_guidebook_popup(tower):
	var tree = get_tree()
	var noti_container = null
	if tree.has_group("noti_vbox"):
		for node in tree.get_nodes_in_group("noti_vbox"):
			if node.name == "GuidebookNotis":
				noti_container = node
		var notification = guidebook_popup.instantiate()
		noti_container.add_child(notification)
		notification.page_index = ally_guidebook_pgs[tower]
		#print("tried adding noti")
	else:
		#print("couldnt find noti container")
		return
