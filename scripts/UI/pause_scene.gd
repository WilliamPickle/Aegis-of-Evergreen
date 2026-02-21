extends MarginContainer
@onready var pause_menu: MarginContainer = $PauseMenuMargin
@onready var pause_screen: MarginContainer = $"."

# variables for the tutorial scene
@onready var button_bar: HBoxContainer = $PauseMenuMargin/ButtonBarVBox/ButtonBarMargin/ButtonBarHBox
@onready var pause_button: Button = $PauseButtonBox/PauseButtonMargin/PauseButton
@onready var tree = get_tree()

func _ready() -> void:
	PauseUi.secondary_ui_open.connect(_on_icon_pressed)
	if tree.has_group("ui_buttons"):
		print("uh boss we found the group")
		print(tree.get_nodes_in_group("ui_buttons"))
		for button in button_bar.get_children():
			button.disabled = true
			button.add_to_group("ui_buttons")
		pause_button.disabled = true
		pause_button.add_to_group("ui_buttons")
	
func _on_pause_button_pressed() -> void:
	PauseUi.toggle_pause(pause_menu)

func _on_icon_pressed(hide_menu) -> void:
	if hide_menu:
		pause_screen.visible = false
	elif !hide_menu:
		pause_screen.visible = true
