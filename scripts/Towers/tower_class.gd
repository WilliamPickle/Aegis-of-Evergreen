extends RigidBody2D
class_name Tower

# The min and max values the tower can be 
# placed around the map.
const MIN_MOUSE_POS := Vector2(-320,-180)
const MAX_MOUSE_POS := Vector2(320,180)
# This variable might be changed later
@export var snapping : float
# the area of the current level
# this is set once tower is intantiated
var map_area : Area2D
# how many objects our tower is colliding with
var total_collision : int = 0
var _is_placing := true
var _can_place := true


func _ready() -> void:
	#contact_monitor = true
	#max_contacts_reported = 25
	
	# Connecting all the body signals
	map_area.body_exited.connect(on_collide.bind(false))
	map_area.body_entered.connect(on_collide.bind(true))
	body_entered.connect(on_collide.bind(true))
	body_exited.connect(on_collide.bind(false))

func on_collide(_body, is_inside : bool):
	if is_inside: # If is inside a body add to total collisions
		total_collision += 1
	else: # If outside a body remove from total collisions
		total_collision -= 1
		
	# If no collision detected let tower be placed
	if total_collision == 0:
		_can_place = true
		modulate = Color(1,1,1,1)
	else:
		modulate = Color(1,0,0,0.5)
		_can_place = false

func place_tower() -> bool:
	if not _can_place:
		return false
	# A bunch of disabling rigidbody functions
	# hopefuly they help with performance.
	_is_placing = false
	can_sleep = true
	sleeping = true
	disable_mode = DISABLE_MODE_MAKE_STATIC
	freeze = true
	
	map_area.body_entered.disconnect(on_collide)
	map_area.body_exited.disconnect(on_collide)
	body_exited.disconnect(on_collide)
	body_entered.disconnect(on_collide)
	
	return true

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if not _is_placing:
		return
	var mouse_pos = get_global_mouse_position()
	var new_tower_pos = Vector2i(mouse_pos / snapping) * snapping
	state.transform.origin = new_tower_pos.clamp(MIN_MOUSE_POS, MAX_MOUSE_POS)
	# Makes the tower snap to a grid given snapping variable
	#state.transform.origin = Vector2(int(mouse_pos.x / snapping )* snapping, 
	#int(mouse_pos.y / snapping) * snapping)
	#state.transform.origin = get_global_mouse_position()
