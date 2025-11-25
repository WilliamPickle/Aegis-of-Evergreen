extends MarginContainer

#@onready var pause_menu: MarginContainer = $PauseMenuMargin
signal pause_activated(pause_state)
var pause_state: bool

## replace object with pause menu
func toggle_pause(object):
	if object.visible:
		object.visible = false
		pause_state = object.visible
		SceneLoader.tint_scene(SceneLoader.current_main_scene, false, true)
		get_tree().paused = false
		emit_signal("pause_activated", pause_state)
		
	elif !object.visible:
		object.visible = true
		pause_state = object.visible
		SceneLoader.tint_scene(SceneLoader.current_main_scene, true, true)
		get_tree().paused = true
		emit_signal("pause_activated", pause_state)

#func _on_pause_button_pressed() -> void:
	#toggle_pause(pause_menu)
