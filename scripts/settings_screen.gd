extends Button
	
func _ready():
	SceneLoader.tint_scene("start_menu",  0.5, 0.5, 0.5);
	
func _on_button_down() -> void:
	SceneLoader.change_scene_visibility("settings_menu",false)
	SceneLoader.tint_scene("start_menu", 1, 1, 1);
	SceneLoader.disable_scene("start_menu", false);
	
