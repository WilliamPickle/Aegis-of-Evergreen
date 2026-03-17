extends Node2D

const SPAWN_TIME : float = 0.25
const RANGE := StatChanger.Type.RANGE

static var duration : float = 10.0
static var debuff_percent : float = -0.5

@onready var blur_effect : ColorRect = $ShaderHolder/BlurEffect
@onready var color_effect : ColorRect = $ShaderHolder/ColorEffect
@onready var effect_timer : Timer = $EffectDuration
@onready var detection_area : Area2D = $DetectionArea

func init(_duration : float, _debuff_percent : float) -> void:
	duration = _duration
	debuff_percent = _debuff_percent

func _ready() -> void:
	var tween := create_tween().set_parallel()
	tween.tween_property(color_effect,"scale", Vector2.ONE, SPAWN_TIME)
	tween.tween_property(blur_effect,"scale", Vector2.ONE, SPAWN_TIME)
	tween.play()
	await tween.finished
	effect_timer.start(duration)
	PlayerStats.gtower_placed.connect(_on_tower_action)
	#detection_area.area_entered.connect(_on_tower_action)
	PlayerStats.upgraded_tower.connect(_on_tower_action)
	effect_timer.timeout.connect(_delete_weather)
	await get_tree().physics_frame
	var towers := detection_area.get_overlapping_areas()
	for tower : Tower in towers:
		_on_tower_action(tower)
	

func _on_tower_action(tower : Tower) -> void:
	print("HARSHSUN APPLICATION RAN!!!!")
	if tower.weather_statuses.has("HarshSun") and is_instance_valid(tower.weather_statuses["HarshSun"]):
		tower.weather_statuses["HarshSun"].queue_free()
	var _duration := effect_timer.time_left
	var stat_changer := StatChanger.new()
	stat_changer.initialize_variables(tower, "HarshSun", RANGE, debuff_percent, _duration)
	tower.add_child(stat_changer)
	tower.weather_statuses.set("HarshSun",stat_changer)



func _delete_weather() -> void:
	var tween := create_tween().set_parallel()
	tween.tween_property(color_effect,"scale", Vector2.ZERO, SPAWN_TIME)
	tween.tween_property(blur_effect,"scale", Vector2.ZERO, SPAWN_TIME)
	tween.play()
	await tween.finished
	WeatherController.weather_ended.emit("HarshSun", true)
	queue_free()
