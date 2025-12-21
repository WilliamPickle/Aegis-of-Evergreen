extends MarginContainer
@onready var pause_menu: MarginContainer = $PauseMenuMargin
@onready var pause_screen: MarginContainer = $"."

func _ready() -> void:
	PauseUi.secondary_ui_open.connect(_on_icon_pressed)
	
func _on_pause_button_pressed() -> void:
	PauseUi.toggle_pause(pause_menu)

func _on_icon_pressed(hide_menu) -> void:
	print("it's been accessed? hide_menu set to:", hide_menu)
	if hide_menu:
		pause_screen.visible = false
	elif !hide_menu:
		pause_screen.visible = true
