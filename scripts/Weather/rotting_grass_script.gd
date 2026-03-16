extends Node2D
class_name RottingGrass

const DAMAGE := StatChanger.Type.DAMAGE

static var duration : float = 5
static var debuff_percent : float = -0.5

@onready var effect_timer : Timer = $EffectDuration
@onready var grass_container : Node2D = $GrassContainer

func init(_duration : float, _debuff_percent : float) -> void:
	duration = _duration
	debuff_percent = _debuff_percent

func _ready() -> void:
	effect_timer.start(duration)
	for grass : AnimatedSprite2D in grass_container.get_children():
		grass.play("spawn")
		grass.animation_finished.connect(func():
			grass.play("idle")
			var area : Area2D = grass.get_child(0)
			_on_tower_present(area.get_overlapping_areas())
		)
		#await get_tree().physics_frame
	PlayerStats.upgraded_tower.connect(_on_tower_upgrade)
		
	effect_timer.timeout.connect(_delete_weather)

func _on_tower_present(towers : Array[Area2D]):
	for tower : Tower in towers:
		if tower is Attacker:
			var stat_changer := StatChanger.new()
			stat_changer.initialize_variables(tower,"RottingGrass",DAMAGE,debuff_percent, effect_timer.time_left, true)
			tower.add_child(stat_changer)
			tower.weather_statuses.set("RottingGrass", stat_changer)
		
func _on_tower_upgrade(tower : Tower):
	if tower.weather_statuses.has("RottingGrass"):
		if is_instance_valid(tower.weather_statuses["RottingGrass"]):
			tower.weather_statuses["RottingGrass"].disable_stat_changes(true, false)
		var stat_changer := StatChanger.new()
		stat_changer.initialize_variables(tower,"RottingGrass",DAMAGE,debuff_percent, effect_timer.time_left, true)
		tower.add_child(stat_changer)
		tower.weather_statuses.set("RottingGrass",stat_changer)
		
func _delete_weather() -> void:
	var final_grass : AnimatedSprite2D
	for grass : AnimatedSprite2D in grass_container.get_children():
		grass.play("despawn")
		final_grass = grass
	await final_grass.animation_finished
	WeatherController.weather_ended.emit("RottingGrass", true)
	queue_free()
