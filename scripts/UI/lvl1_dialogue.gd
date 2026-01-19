extends DialogueBox


func _ready() -> void:
	super._ready()
	continue_button.button_down.connect(display_tutorial)
	
	
func display_tutorial():
	if cur_label_index == 3:
		SceneLoader.load_scene("res://scenes/UI/tutorial_menu.tscn", "tutorial_menu")
		SceneLoader.tint_scene()
