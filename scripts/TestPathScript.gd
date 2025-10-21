extends PathFollow2D
@onready var path_follow: PathFollow2D = $"."
@export_range(0, 1, 0.05) var speed = 0.05
@onready var walking_bush: AnimatedSprite2D = $WalkingBush

var cur_position_x = 0
var prev_position_x = 0

func _process(delta: float) -> void:
	progress_ratio += delta * speed
	cur_position_x = path_follow.get_global_position().x
	
	if (cur_position_x - prev_position_x < 0):
		walking_bush.flip_h = false
	else:
		walking_bush.flip_h = true
	
	
	print(cur_position_x - prev_position_x)
	prev_position_x = cur_position_x
