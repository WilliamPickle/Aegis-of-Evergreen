extends Node

enum ControlState {
	PLAYING,
	PAUSED,
	PLACING_TOWER,
	VIEWING_TOWER,
}

var current_states : Array[ControlState] = [ControlState.PLAYING]

#func _ready() -> void:
	#process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE and current_states.has(ControlState.PLAYING):
			get_tree().paused = not get_tree().paused
	#print("In controlHandler:",current_states)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_tower_hitboxes") and _only_has_state(ControlState.VIEWING_TOWER,[ControlState.PLAYING]):
		Tower.current_tower.draw_hitboxes(true)
		current_states.erase(ControlState.VIEWING_TOWER)

# checks if current_states only has the given state,
# excluding the given states.
func _only_has_state(state : ControlState, excludes : Array = []) -> bool:
	# if state doesnt exist in the current_states or 
	# the excluding list +1 is less than current_states
	# we guarantee there are unwanted states present.
	if not current_states.has(state) or (excludes.size()+1 < current_states.size()):
		return false
	excludes.append(state)
	excludes.sort()
	return excludes == current_states
	
## adds the state to the current_states list
## at the state's value, keeping the list sorted. 
func add_state(state : ControlState):
	if not current_states.has(state):
		if state >= current_states.size():
			current_states.append(state)
		else:
			current_states.insert(state,state)
