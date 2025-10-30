extends Camera2D
@onready var camera: Camera2D = $"."

const zoom_max = 1.8
const zoom_min = 4
const zoom_rate = 0.1
const panning_drag = 0.1

var initial_mouse_pos = 0
var cur_mouse_pos = 0

func _input(event: InputEvent) -> void:
	if event.is_action("MouseWheelUp"):
		if camera.zoom < Vector2(zoom_min, zoom_min):
			camera.zoom += Vector2(zoom_rate, zoom_rate)

	if event.is_action("MouseWheelDown"):
		if camera.zoom > Vector2(zoom_max, zoom_max):
			camera.zoom += Vector2(-zoom_rate, -zoom_rate)
			
	if Input.is_action_just_pressed("MouseMiddle"):
		initial_mouse_pos = get_global_mouse_position()

	if Input.is_action_pressed("MouseMiddle"):
		cur_mouse_pos = get_global_mouse_position()
		camera.position += (initial_mouse_pos - cur_mouse_pos) * panning_drag
		
		
func _process(delta: float) -> void:
	camera.position.x = clamp(camera.position.x, -320 + 576/camera.zoom.x, 320 - 576/camera.zoom.x)
	camera.position.y = clamp(camera.position.y, -180 + 324/camera.zoom.y, 180 - 324/camera.zoom.y)
