extends Area2D
class_name Tower


signal tower_placed
# The min and max values the tower can be 
# placed around the map.
const MIN_MOUSE_POS := Vector2(-320,-180)
const MAX_MOUSE_POS := Vector2(320,180)
const CONTROLS_STATES = ControlHandler.ControlState

# Used to draw the hitbox of the selected tower
static var current_tower : Tower

# Turn to const once variable is finalized
const snapping : float = 2.0

# Class shared vars
static var Game_Data = JSON.parse_string(FileAccess.get_file_as_string("res://Game Data.json"))
@export var data_resource : DataResource = DataResource.new()
@onready var object_data = Game_Data[data_resource.class_type][data_resource.object]
	# Tower class stats
@export var level : int = 0
@onready var cost : float = object_data["cost"][level]
@onready var range : float = object_data["range"][level]
@onready var sell_back_ratio = 0.5
@onready var sell_value : float = floori(object_data["cost"][level] * sell_back_ratio / 1)
var total_spent = 0


# the area of the current level
# this is set once tower is intantiated
var map_area : Area2D
var can_draw := true
@onready var sprite : AnimatedSprite2D = $Image
@onready var upgrade_ui : towerUpgrader = $UpgradeUI
@onready var button : Button = $Button
@onready var range_area : Area2D = $Range
@onready var range_collider : CollisionShape2D = $Range/RangeCollision
#@onready var range_area : Area2D = $Range
#@onready var _attack_cooldown : Timer = $AttackCoolDOwn
#func _init(area : Area2D) -> void:
	#map_area = area
	
# This is to track who's applied a status effect
# on the tower. Makes sure effects don't stack
var status_applied_list = []

func _ready() -> void:
	# contact_monitor = true
	# max_contacts_reported = 25
	# Connecting all the body signals
	var shape = CircleShape2D.new()
	shape.radius = range
	range_collider.shape = shape
	map_area.area_exited.connect(on_tower_collision)
	map_area.area_entered.connect(on_tower_collision)
	area_entered.connect(on_tower_collision)
	area_exited.connect(on_tower_collision)
	
	button.pressed.connect(draw_hitboxes)
	current_tower = self
	set_collision_layer_value(3, true)
	set_collision_layer_value(1, false)


func _draw() -> void:
	if can_draw:
		draw_circle(Vector2.ZERO, range_collider.shape.radius, Color(0.15, 0.15, 0.15, 0.25))
		draw_circle(Vector2.ZERO, range_collider.shape.radius, Color(0.15, 0.15, 0.15, 0.25), false, 2)
		draw_circle(Vector2.ZERO, $BodyCollision.shape.radius, Color(0.15, 0.15, 0.15, 0.25), false, 1.5)

func draw_hitboxes(deleting : bool = false) -> void:
	# will delete the towers range
	if deleting:
		can_draw = false
		upgrade_ui.visible = false
		queue_redraw()
		return
	
	# Safely add our correct state
	ControlHandler.add_state(CONTROLS_STATES.VIEWING_TOWER)
	
	# If placing tower, dont let us view any other tower ranges
	if ControlHandler.current_states.has(CONTROLS_STATES.PLACING_TOWER):
		return
	# If isnt viewing a range set to self.
	elif current_tower == null:
		current_tower = self
	# if player selects a different tower, delete current range
	elif current_tower != self:
		current_tower.draw_hitboxes(true)
		current_tower = self
	elif can_draw == true: # If we were already our own range
	# delete the range and remove from states
		ControlHandler.current_states.erase(CONTROLS_STATES.VIEWING_TOWER)
	can_draw = not can_draw
	upgrade_ui.visible = can_draw
	queue_redraw()

## Visual function, turns tower red if unable to place or green if able to place.
func on_tower_collision(_body):
	# If no collision detected let tower be placed
	if get_overlapping_areas().size() > 0:
		modulate = Color(1,0,0,0.5)
	else:
		modulate = Color(1,1,1,1)

## Function that returns false if player cant place down tower,
## or returns true if player can place tower, while simultaneously
## placing it and disabling functions.
func place_tower() -> bool:
	if get_overlapping_areas().size() > 0:
		var notif := Error_Notification.new()
		map_area.add_child(notif)
		notif.send_notif(global_position,"can't place here")
		return false
		
	if !PlayerStats.purchase_item(cost):
		queue_free()
		Tower_Placement.reset_data()
		var notif := Error_Notification.new()
		map_area.add_child(notif)
		notif.send_notif(global_position,"not enough funds")
		return true
	# Makes so _process can't run
	set_process(false)
	# Enabled the button functionality.
	button.visible = true
	# Disable the visibility of tower hitbox
	can_draw = false
	upgrade_ui.visible = false
	# THIS MIGHT NEED CHANGING LATER
	#current_tower = null
	
	cost = object_data["cost"][1]
	
	# Draw the changes
	queue_redraw()
	
	# Disable the placement collision checks
	map_area.area_entered.disconnect(on_tower_collision)
	map_area.area_exited.disconnect(on_tower_collision)
	area_exited.disconnect(on_tower_collision)
	area_entered.disconnect(on_tower_collision)
	
	# Tell corresponding sub class that the tower succesfully was placed
	tower_placed.emit()
	
	return true

func upgrade_tower() -> void:
	total_spent += cost
	sell_value = floori(total_spent * sell_back_ratio / 1)
	level += 1
	if level == 1:
		cost = object_data["cost"][2]
	range = object_data["range"][level]
	range_collider.shape.radius = range
	queue_redraw()

# When tower is first intantiated, the tower follows mouse position
# and updates draw().
func _process(_delta: float) -> void:
	queue_redraw()
	var mouse_pos := get_global_mouse_position()
	# Help prevent the placement looking too smooth.
	var new_tower_pos := Vector2i(mouse_pos / snapping) * snapping
	global_position = new_tower_pos.clamp(MIN_MOUSE_POS, MAX_MOUSE_POS)
