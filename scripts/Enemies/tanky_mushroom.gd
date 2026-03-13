extends Enemy
@onready var timer: Timer = $Timer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


var slow_down : bool = true

func _ready() -> void:
	super._ready()
	#timer.timeout.connect(change_speed)
	#sprite.frame_changed.connect(change_speed_2)
	
func change_speed():
	if slow_down:
		speed_variance = -1
	else:
		speed_variance = 0
	slow_down = !slow_down
