extends Button
	
func _ready():
	SceneLoader.tint_scene("start_menu",  0.5, 0.5, 0.5);
	
func _on_button_down() -> void:
<<<<<<< HEAD
	#SceneLoader.quick_add_scene("res://scenes/start_menu.tscn","start_menu","settings_menu")
	SceneLoader.change_scene_visibility("settings_menu",false)
=======
	SceneLoader.delete_scene("test_scene")
	SceneLoader.tint_scene("start_menu", 1, 1, 1);
	SceneLoader.disable_scene("start_menu", false);
>>>>>>> 3284791f8eeb6138986295b9b8c94622f392e63d
