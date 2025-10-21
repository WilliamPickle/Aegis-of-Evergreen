extends RigidBody2D
class_name Tower

@export var sprite : Sprite2D
var map_area : Area2D
var total_collision : int = 0
var _is_placing := true
var _can_place := true

func _ready() -> void:
	#contact_monitor = true
	#max_contacts_reported = 25
	map_area.body_exited.connect(on_collide.bind(true))
	map_area.body_entered.connect(on_collide.bind(false))
	body_entered.connect(on_collide.bind(false))
	body_exited.connect(on_collide.bind(true))

func on_collide(body, is_inside : bool):
	if is_inside:
		total_collision += 1
	else:
		total_collision -= 1
		
	if total_collision == 0:
		_can_place = true
		modulate = Color(1,1,1,1)
	else:
		modulate = Color(1,0,0,0.5)
		_can_place = false

func place_tower() -> bool:
	if not _can_place:
		return false
	_is_placing = false
	#can_sleep = true
	sleeping = true
	disable_mode = DISABLE_MODE_MAKE_STATIC
	freeze = true
	
	map_area.body_entered.disconnect(on_collide)
	map_area.body_exited.disconnect(on_collide)
	
	return true

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if not _is_placing:
		return
	state.transform.origin = get_global_mouse_position()
