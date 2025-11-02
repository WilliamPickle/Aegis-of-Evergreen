extends RigidBody2D
class_name Tower

# The min and max values the tower can be 
# placed around the map.
const MIN_MOUSE_POS := Vector2(-320,-180)
const MAX_MOUSE_POS := Vector2(320,180)
const CONTROLS_STATES = ControlHandler.ControlState

static var current_tower : Tower
# This variable might be changed later
@export var snapping : float
@export var image_radius : int
# the area of the current level
# this is set once tower is intantiated
var map_area : Area2D
# how many objects our tower is colliding with
var _total_collisions : int = 0
var can_draw := true

@onready var button : Button = $Button

func _ready() -> void:
	# contact_monitor = true
	# max_contacts_reported = 25
	# Connecting all the body signals
	map_area.body_exited.connect(on_collide.bind(false))
	map_area.body_entered.connect(on_collide.bind(true))
	body_entered.connect(on_collide.bind(true))
	body_exited.connect(on_collide.bind(false))
	button.pressed.connect(draw_hitboxes)
	current_tower = self

func _draw() -> void:
	if can_draw:
		draw_circle(Vector2.ZERO, $Range/RangeCollision.shape.radius, Color(1, 1, 1, 0.25))
		draw_arc(Vector2.ZERO, $Range/RangeCollision.shape.radius + 1,0, 360, 50,Color(1,1,1,0.4), 2)
		draw_arc(Vector2.ZERO, $BodyCollision.shape.radius,0, 360, 50,Color(1,1,1,0.4), 1)

func draw_hitboxes(deleting : bool = false) -> void:
	if deleting:
		can_draw = false
		queue_redraw()
		return
	
	# Add our correct state
	if not ControlHandler.current_states.has(CONTROLS_STATES.VIEWING_TOWER):
		ControlHandler.current_states.append(CONTROLS_STATES.VIEWING_TOWER)
	
	if current_tower == null:
		current_tower = self
	elif current_tower != self:
		current_tower.draw_hitboxes(true)
		current_tower = self
	elif can_draw == true: # We arent viewing range if can_draw
	# is set to true, because on line 60 it changes to false
		ControlHandler.current_states.erase(CONTROLS_STATES.VIEWING_TOWER)
	can_draw = not can_draw
	queue_redraw()


func on_collide(_body, is_inside : bool):
	if is_inside: # If is inside a body add to total collisions
		_total_collisions += 1
	else: # If outside a body remove from total collisions
		_total_collisions -= 1
		
	# If no collision detected let tower be placed
	if _total_collisions == 0:
		modulate = Color(1,1,1,1)
	else:
		modulate = Color(1,0,0,0.5)

func place_tower() -> bool:
	if _total_collisions != 0:
		return false
	# A bunch of disabling rigidbody functions
	# hopefuly they help with performance.
	button.visible = true
	sleeping = true
	freeze = true
	can_draw = false
	queue_redraw()
	
	# Disable the placement collision checks
	map_area.body_entered.disconnect(on_collide)
	map_area.body_exited.disconnect(on_collide)
	body_exited.disconnect(on_collide)
	body_entered.disconnect(on_collide)
	
	ControlHandler.current_states.erase(CONTROLS_STATES.PLACING_TOWER)
	
	return true

# This function is automatically disabled once
# its sleeping is set to true.
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# in the next frame draw a new object given the _draw func
	queue_redraw()
	var mouse_pos := get_global_mouse_position()
	var new_tower_pos := Vector2i(mouse_pos / snapping) * snapping
	state.transform.origin = new_tower_pos.clamp(MIN_MOUSE_POS, MAX_MOUSE_POS)
