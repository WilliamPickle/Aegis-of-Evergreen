extends MarginContainer

@onready var pause_menu: MarginContainer = $PauseMenuMargin

func toggle_pause(object):
	if object.visible:
		object.visible = false
		SceneLoader.tint_scene(SceneLoader.current_main_scene, false, true)
		get_tree().paused = false
		
	elif !object.visible:
		object.visible = true
		SceneLoader.tint_scene(SceneLoader.current_main_scene, true, true)
		get_tree().paused = true

func _on_pause_button_pressed() -> void:
	toggle_pause(pause_menu)
