extends Button

func _on_button_down() -> void:
	SceneLoader.quick_add_scene("res://scenes/start_menu.tscn","start_menu","test_scene")
