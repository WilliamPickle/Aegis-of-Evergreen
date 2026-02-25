extends AnimatedSprite2D
@export_group ("scale ranges")
@export var x_min_range_scale:float
@export var x_max_range_scale:float
@export var y_min_range_scale:float
@export var y_max_range_scale:float
@export_group ("position ranges")
@export var x_min_range_position:float
@export var x_max_range_position:float
@export var y_min_range_position:float
@export var y_max_range_position:float
@export_group("timer ranges")
@export var min_timer:float
@export var max_timer:float
var rng = RandomNumberGenerator.new()
@onready var timer:=$Timer
#randomize scale 0.8 to 1.1(Might need changing depending on location)
#delaying fish spawn
#animation finished wait for 0.1 to 10 seconds
#randomize location a little 
#original position (39,-81)
#use global_position
func _ready() -> void:
	rng.randomize()
	scale = Vector2(1,1)
	animation_finished.connect(play_animation)
	
	
func play_animation():
	timer.start(rng.randf_range(min_timer,max_timer))
	await timer.timeout
	play("default")
	scale = Vector2(rng.randf_range(x_min_range_scale,x_max_range_scale),rng.randf_range(y_min_range_scale,y_max_range_scale))
	global_position = Vector2(rng.randf_range(x_min_range_position,x_max_range_position),rng.randf_range(y_min_range_position,y_max_range_position))
	#randomize wait time
