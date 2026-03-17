extends Area2D
class_name Wind

const MAX_TRAVEL_DISTANCE = 200
const WALK_SPEED = StatChanger.Type.WALK_SPEED
const POS_OFFSET := Vector2(20,20)
const MAX_SPEED := 0.75 # Really fast
const MIN_SPEED := 2.5 # Really slow

static var duration : float = 500
static var buff_percent : float = 10
static var debuff_percent : float = -0.5
static var wind_direction : int = 1
static var min_pos : Vector2 = Vector2(-360,-180)
static var max_pos : Vector2 = Vector2(360,180)
static var is_visible : bool = true

@onready var wind_node := $AnimationNode
@onready var effect_timer : Timer = $EffectDuration

var ran = RandomNumberGenerator.new()

## Sets the defualt values for wind. Direction can eighter be 1 for right, or -1 for left.
func init(_duration : float, _buff_percent : float, _debuff_percent : float, direction : int, _is_visible : bool, _min_pos : Vector2, _max_pos : Vector2):
	duration = _duration
	buff_percent = _buff_percent
	debuff_percent = _debuff_percent
	wind_direction = direction
	is_visible = _is_visible
	min_pos = _min_pos
	max_pos = _max_pos


func _ready() -> void:
	effect_timer.start(duration)
	effect_timer.timeout.connect(_delete_wind)
	
	if is_visible:
		min_pos += POS_OFFSET
		max_pos -= POS_OFFSET
		wind_node.visible = true
		for wind : AnimatedSprite2D in wind_node.get_children():
			ran.randomize()
			if wind_direction == -1:
				wind.flip_h = true
			_randomize_wind(wind)
			wind.animation_finished.connect(_randomize_wind.bind(wind))
	
	var enemies := get_overlapping_areas()
	for enemy : Enemy in enemies:
		print("Overlapping stuff ran too!!")
		_enemy_reversed(enemy)
		#enemy.reversed.connect(_enemy_reversed)

	area_entered.connect(_enemy_reversed)


func _randomize_wind(wind : AnimatedSprite2D):
	var new_x = ran.randf_range(min_pos.x, max_pos.x)
	var new_y = ran.randf_range(min_pos.y, max_pos.y)
	wind.global_position = Vector2(new_x, new_y)
	var travel_destination : Vector2 = wind.global_position + (Vector2(MAX_TRAVEL_DISTANCE * ran.randf() * wind_direction, 0))
	var speed := randf_range(MIN_SPEED, MAX_SPEED)
	wind.speed_scale = 1/speed
	var tween := create_tween()
	tween.tween_property(wind,"global_position", travel_destination, speed)
	tween.play()
	wind.play("default")

func _new_enemy_entered(enemy : Enemy) -> void:
	print("AREA ENTERED FUNC RAN")
	var stat_changer := StatChanger.new()
	stat_changer.initialize_variables(enemy, "wind", WALK_SPEED, buff_percent, effect_timer.time_left)
	enemy.add_child(stat_changer)
	enemy.weather_statuses.set("wind", stat_changer)
	enemy.reversed.connect(_enemy_reversed)
	
	
func _enemy_reversed(enemy : Enemy) -> void:
	if !enemy.weather_statuses.get("wind", false):
		enemy.reversed.connect(_enemy_reversed)
	elif is_instance_valid(enemy.weather_statuses["wind"]):
		enemy.weather_statuses["wind"].disable_stat_changes()
		
	#if enemy.weather_statuses.get("wind", false) and is_instance_valid(enemy.weather_statuses["wind"]):

	var stat_changer := StatChanger.new()
	var stat_percent : float
	print("For wind this is what travel direction is: ", enemy.travel_direction)
	if enemy.travel_direction  * wind_direction == 1:
		stat_percent = buff_percent
	else:
		stat_percent = debuff_percent

	stat_changer.initialize_variables(enemy, "wind", WALK_SPEED, stat_percent, effect_timer.time_left)
	enemy.add_child(stat_changer)
	enemy.weather_statuses.set("wind", stat_changer)

func _delete_wind() -> void:
	var enemies := get_overlapping_areas()
	for enemy : Enemy in enemies:
		enemy.weather_statuses.erase("wind")
		#enemy.reversed.disconnect(_enemy_reversed)
		#area_entered.disconnect(_enemy_reversed)
		print(enemy.weather_statuses)
	#print("---WIND HAS ENDED---")
	WeatherController.weather_ended.emit("Wind", false)
	queue_free()
