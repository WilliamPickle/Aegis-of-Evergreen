extends Button
class_name Tower_Placement

# The dictionary of all towers
const towers : Dictionary = {
	"ranger" = preload("res://scenes/Towers/ranger.tscn"),
	"druid" = preload("res://scenes/Towers/druid/druid.tscn"),
	"chipmunk" = preload("res://scenes/Towers/chipmunk/chipmunk.tscn"),
	"bee" = preload("res://scenes/Towers/bee/bee.tscn"),
	"flytrap" = preload("res://scenes/Towers/flytrap/flytrap.tscn"),
	"god" = preload("res://scenes/Towers/god/god.tscn"),
}
const CONTROLS_STATES = ControlHandler.ControlState
static var is_placing := false
static var new_tower : Tower
# Refrence the area to add to the tower once spawned
@export var map_area : Area2D
# The tower type, if its squirrel or goat tower
@export_enum("tower", "chipmunk") var tower_type : String

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
	new_tower.total_spent += new_tower.object_data["cost"][0]


func _unhandled_input(event: InputEvent) -> void:
	if !is_instance_valid(new_tower):
		reset_data()

	if event.is_action_pressed("place_tower") and is_placing:
		var can_place : bool = new_tower.place_tower()
		if can_place:
			reset_data()

	elif event.is_action("cancel_placement") and is_placing:
		new_tower.queue_free()
		reset_data()
		
static func reset_data() -> void:
	new_tower = null
	is_placing = false
	ControlHandler.current_states.erase(CONTROLS_STATES.PLACING_TOWER)
