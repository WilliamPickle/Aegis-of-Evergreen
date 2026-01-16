extends Button

var fast_forward_on: bool = false
var speed_multiplier: float = 4

func _ready() -> void:
	button_down.connect(toggle_fast_forward)
	
func toggle_fast_forward():
	if !fast_forward_on:
		Engine.time_scale = speed_multiplier
		fast_forward_on = true
	elif fast_forward_on:
		Engine.time_scale = 1
		fast_forward_on = false
