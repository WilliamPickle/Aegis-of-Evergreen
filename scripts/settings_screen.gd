extends Button
	
func _ready():
	SceneLoader.tint_scene("start_menu",  0.5, 0.5, 0.5);
	
func _on_button_down() -> void:
	SceneLoader.delete_scene("test_scene")
	SceneLoader.tint_scene("start_menu", 1, 1, 1);
	SceneLoader.disable_scene("start_menu", false);
