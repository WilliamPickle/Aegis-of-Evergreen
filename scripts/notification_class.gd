extends Label
class_name Error_Notification

const travel_distance := Vector2(0,-15)
const font = "res://assets/fonts/error_notification.tres"
const big_font = "res://assets/fonts/wave_clear.tres"
const font_dict = {
	"error" : "res://assets/fonts/error_notification.tres",
	"wave_clear" : "res://assets/fonts/wave_clear.tres"
}
#const duration := 0.5
var tween = create_tween().set_parallel()

func send_notif(position : Vector2, message : String, duration : float = 0.5, type : String = "error") -> void:
	z_index = 100
	global_position = position - Vector2(20,5)
	#set_anchors_preset(Control.PRESET_CENTER)
	label_settings = load(font_dict[type])
	text = message
	var new_pos = global_position + travel_distance
	tween.tween_property(self,"position", new_pos, duration)
	#tween.tween_property(self, "scale", Vector2(0.75, 0.75), duration)
	tween.play()
	
	await tween.finished
	queue_free()
