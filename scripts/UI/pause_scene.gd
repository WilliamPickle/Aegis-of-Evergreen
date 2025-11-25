extends MarginContainer
@onready var pause_menu: MarginContainer = $PauseMenuMargin

func _on_pause_button_pressed() -> void:
	PauseUi.toggle_pause(pause_menu)
