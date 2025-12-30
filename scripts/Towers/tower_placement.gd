extends Button
class_name Tower_Placement

# The dictionary of all towers
const towers : Dictionary = {
	"Tower" = preload("res://scenes/Towers/Tower.tscn"),
	"Chipmunk" = preload("res://scenes/Towers/chipmunk.tscn"),
	"Honey_Comb" = preload("res://scenes/Towers/honey_comb.tscn"),
}
const CONTROLS_STATES = ControlHandler.ControlState
static var is_placing := false
static var new_tower : Tower
# Refrence the area to add to the tower once spawned
@export var map_area : Area2D
# The tower type, if its squirrel or goat tower
@export_enum("Tower", "Chipmunk") var tower_type : String

func _ready() -> void:
	button_down.connect(add_tower)
	towers.keys()

# When player clicks on the spawn tower function.
func add_tower() -> void:
	ControlHandler.current_states.erase(CONTROLS_STATES.VIEWING_TOWER)
	if is_placing:
		Tower.current_tower.queue_free()
		Tower.current_tower = null
	is_placing = true
	if Tower.current_tower != null:
		Tower.current_tower.draw_hitboxes(true)
	ControlHandler.add_state(CONTROLS_STATES.PLACING_TOWER)
	new_tower = towers[tower_type].instantiate()
	new_tower.map_area = map_area
	new_tower.global_position = get_global_mouse_position()
	map_area.add_child(new_tower)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("place_tower") and is_placing:
		var can_place : bool = new_tower.place_tower()
		if not can_place: return
		new_tower = null
		is_placing = false
	elif event.is_action("cancel_placement") and is_placing:
		new_tower.queue_free()
		new_tower = null
		is_placing = false
		ControlHandler.current_states.erase(CONTROLS_STATES.PLACING_TOWER)
		
