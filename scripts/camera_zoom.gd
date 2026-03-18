extends Camera2D
signal camera_moved
@onready var camera: Camera2D = $"."
##offset by how much the map is extended by in each direction relative to the viewport
@export var offset_r : float = 0
@export var offset_u : float = 0
@export var offset_l : float = 0
@export var offset_d : float = 0

# size of the actual camera2d viewport
const screen_width : float = 640 / 2
const screen_height : float = 360 / 2
@export var zoom_max : float = 2
@export var zoom_min : float = 4
const zoom_rate = 0.1
const panning_drag = 0.1

var initial_mouse_pos := Vector2.ZERO
var cur_mouse_pos := Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event.is_action("MouseWheelUp"):
		if camera.zoom < Vector2(zoom_min, zoom_min):
			camera.zoom += Vector2(zoom_rate, zoom_rate)

	if event.is_action("MouseWheelDown"):
		if camera.zoom > Vector2(zoom_max, zoom_max):
			camera.zoom += Vector2(-zoom_rate, -zoom_rate)
			
	if Input.is_action_just_pressed("MouseMiddle") or Input.is_action_just_pressed("move_camera"):
		initial_mouse_pos = get_global_mouse_position()

	if Input.is_action_pressed("MouseMiddle") or Input.is_action_pressed("move_camera"):
		cur_mouse_pos = get_global_mouse_position()
		camera.position += (initial_mouse_pos - cur_mouse_pos) * panning_drag
		emit_signal("camera_moved")
		
		
func _process(_delta: float) -> void:
	camera.position.x = clamp(camera.position.x, -screen_width - offset_l + (screen_width * zoom_max)/camera.zoom.x, screen_width + offset_r - (screen_width * zoom_max)/camera.zoom.x)
	camera.position.y = clamp(camera.position.y, -screen_height - offset_u + (screen_height * zoom_max)/camera.zoom.y, screen_height + offset_d - (screen_height * zoom_max)/camera.zoom.y)
