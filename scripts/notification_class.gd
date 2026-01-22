extends Label
class_name Error_Notification

const travel_distance := Vector2(0,-15)
const font = "res://assets/fonts/error_notification.tres"
const duration := 0.5
var tween = create_tween().set_parallel()

func send_notif(position : Vector2, message : String) -> void:
	z_index = 100
	global_position = position - Vector2(0,5)
	set_anchors_preset(Control.PRESET_CENTER)
	label_settings = load(font)
	text = message
	var new_pos = global_position + travel_distance
	tween.tween_property(self,"position", new_pos, duration)
	#tween.tween_property(self, "scale", Vector2(0.75, 0.75), duration)
	tween.play()
	
	await tween.finished
	queue_free()
