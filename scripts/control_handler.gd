extends Node

enum ControlState {
	PLAYING,
	PLACING_TOWER,
	VIEWING_TOWER,
}

var tower = preload("res://scripts/Towers/tower_class.gd")
var current_states := [ControlState.PLAYING]

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE and current_states.has(ControlState.PLAYING):
			get_tree().paused = not get_tree().paused
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_tower_hitboxes") and current_states.has(ControlState.VIEWING_TOWER):
		tower.current_tower.draw_hitboxes(true)
		current_states.erase(ControlState.VIEWING_TOWER)
