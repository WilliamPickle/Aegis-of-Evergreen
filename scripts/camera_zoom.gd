extends Camera2D
@onready var camera: Camera2D = $"."

const zoom_max = 1.8
const zoom_min = 3
const zoom_rate = 0.1

var initial_mouse_pos = 0
var prev_mouse_pos = 0

func _input(event: InputEvent) -> void:
	if event.is_action("MouseWheelUp"):
		if camera.zoom < Vector2(zoom_min, zoom_min):
			camera.zoom += Vector2(zoom_rate, zoom_rate)
		#camera.zoom.clamp(Vector2(zoom_min, zoom_min), Vector2(zoom_max, zoom_max))
	if event.is_action("MouseWheelDown"):
		if camera.zoom > Vector2(zoom_max, zoom_max):
			camera.zoom += Vector2(-zoom_rate, -zoom_rate)
	if Input.is_action_just_pressed("MouseMiddle"):
		initial_mouse_pos = get_global_mouse_position
		#cur_mouse_pos = get_global_mouse_position().x
		#camera.position.x = cur_mouse_pos - prev_mouse_pos
		#prev_mouse_pos = cur_mouse_pos
	if event.is_action()
		camera.position = get_global_mouse_position()
		
	if Input
			

#func _input(event: InputEvent) -> void:
	#if event.is_action()
