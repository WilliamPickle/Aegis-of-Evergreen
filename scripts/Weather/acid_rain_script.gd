extends AnimatedSprite2D

const DOT = StatChanger.Type.DOT

@onready var detection_area : Area2D = $EnemyDetectionArea
@onready var effect_timer : Timer = $EffectDuration

static var buff_percent : float = 1
static var duration : float = 10

func init(_duration : float, _buff_percent : float) -> void:
	duration = _duration
	buff_percent = _buff_percent
	
func _ready() -> void:
	play("spawn")
	effect_timer.start(duration)
	effect_timer.timeout.connect(_delete_weather)
	detection_area.area_entered.connect(_enemy_entered)
	await animation_finished
	play("rain")
	
	
func _enemy_entered(enemy : Enemy) -> void:
	var stat_changer = StatChanger.new()
	stat_changer.initialize_variables(enemy, "AcidRain", DOT, buff_percent, effect_timer.time_left)
	enemy.add_child(stat_changer)
	enemy.weather_statuses.set("AcidRain", stat_changer)
	
func _delete_weather() -> void:
	var enemies = detection_area.get_overlapping_areas()
	for enemy : Enemy in enemies:
		enemy.weather_statuses.erase("AcidRain")
	play("despawn")
	await animation_finished
	WeatherController.weather_ended.emit("AcidRain", false)
	queue_free()
