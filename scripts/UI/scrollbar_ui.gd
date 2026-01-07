extends UserInterface

# placement mask is the collision area where towers can't be placed on
@export var placement_mask : Area2D
@export_enum("tower", "chipmunk","bee","flytrap") var card_type : Array[String] = []
@export var scroll_container: HBoxContainer

# add any tower card here
const cards : Dictionary = {
	"tower" = preload("res://assets/sprites/towers/base_tower_card.png"), 
	"chipmunk" = preload("res://assets/sprites/towers/chipmunk_card.png"),
	"bee" = preload("res://assets/sprites/towers/base_tower_card.png"),
	"flytrap" = preload("res://assets/sprites/towers/base_tower_card.png"),
}

func _ready() -> void:
	super._ready()
	for tower in card_type:
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
		new_card.add_theme_stylebox_override("hover", card_image)
		new_card.add_theme_stylebox_override("pressed", dark_card_image)
		new_card.add_theme_stylebox_override("hover_pressed", dark_card_image)
