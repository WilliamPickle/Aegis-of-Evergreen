extends Button

func _on_button_down() -> void:
	#SceneLoader.quick_add_scene("res://scenes/start_menu.tscn","start_menu","settings_menu")
	SceneLoader.change_scene_visibility("settings_menu",false)
