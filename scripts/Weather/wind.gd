extends Area2D
class_name Wind

const MAX_TRAVEL_DISTANCE = 200
const WALK_SPEED = StatChanger.Type.WALK_SPEED

static var duration : float = 500
static var buff_percent : float = 10
static var debuff_percent : float = -0.5
static var wind_direction : int = 1

@onready var animation := $AnimatedSprite2D
@onready var effect_duration : Timer = $EffectDuration

var r = RandomNumberGenerator.new()

## Sets the defualt values for wind. Direction can eighter be 1 for right, or -1 for left.
func init(_duration : float, _buff_percent : float, _debuff_percent : float, direction : int):
	duration = _duration
	buff_percent = _buff_percent
	debuff_percent = _debuff_percent
	wind_direction = direction


func _ready() -> void:
	print("---WIND HAS STARTED---")
	if wind_direction == -1:
		animation.flip_h = true
	effect_duration.start(duration)
	effect_duration.timeout.connect(_delete_wind)
	r.randomize()
	# IGNORE THIS FOR NOW!!!
	animation.animation_finished.connect(func():
		animation.global_position = Vector2(r.randi_range(-300,300), r.randi_range(-160,160))
		#print("Global Pos: ", animation.global_position)
		var travel_destination : Vector2 = animation.global_position + (Vector2(MAX_TRAVEL_DISTANCE * r.randf() * wind_direction, 0))
		#print("Travel destination: ", travel_destination)
		#print("New end pos: ", animation.global_position + travel_destination)
		var tween := create_tween()
		tween.tween_property(animation,"global_position", travel_destination, 1)
		tween.play()
		animation.play("default")
	)
	var enemies := get_overlapping_areas()
	for enemy : Enemy in enemies:
		_enemy_reversed(enemy)

	area_entered.connect(_new_enemy_entered)

func _new_enemy_entered(enemy : Enemy) -> void:
	var stat_changer := StatChanger.new()
	stat_changer.initialize_variables(enemy, "wind", WALK_SPEED, buff_percent, effect_duration.time_left)
	enemy.add_child(stat_changer)
	enemy.weather_statuses.set("wind", stat_changer)
	enemy.reversed.connect(_enemy_reversed)
	
	
func _enemy_reversed(enemy : Enemy) -> void:
	if is_instance_valid(enemy.weather_statuses["wind"]):
		enemy.weather_statuses["wind"].disable_stat_changes()

	var stat_changer := StatChanger.new()
	var stat_percent : float
	
	if enemy.travel_direction  * wind_direction == 1:
		stat_percent = buff_percent
	else:
		stat_percent = debuff_percent

	stat_changer.initialize_variables(enemy, "wind", WALK_SPEED, stat_percent, effect_duration.time_left)
	enemy.add_child(stat_changer)
	enemy.weather_statuses.set("wind", stat_changer)

func _delete_wind() -> void:
	var enemies := get_overlapping_areas()
	for enemy : Enemy in enemies:
		enemy.weather_statuses.erase("wind")
	print("---WIND HAS ENDED---")
	queue_free()
