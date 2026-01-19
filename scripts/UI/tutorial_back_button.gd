extends Icon

# Overrides the load_icon_scene() because
# back button doesnt load a scene but removes it and 
# isnt worth adding a whole new function for a 1 off thing
func load_icon_scene():
	SceneLoader.change_scene_visibility("tutorial_menu",false)
	SceneLoader.tint_scene(SceneLoader.current_main_scene,false)
	Icon.ui_open = false
	PauseUi.emit_signal("secondary_ui_open", false)
