extends AnimatedSprite2D
class_name Rain

const ATK_COOLDOWN = StatChanger.Type.ATK_COOLDOWN
# Static vals are for testing, they get overwritten during _init()
static var buff_percent : float = -0.5
static var duration : float = 20

@onready var detection_area : Area2D = $TowerDetectionArea
@onready var effect_duration : Timer = $EffectDuration

func init(_duration : float, _buff_percent: float) -> void:
	duration = _duration
	buff_percent = _buff_percent

func _ready() -> void:
	print("This is parent: ", get_parent())
	print(detection_area)
	play("spawn")
	await animation_finished
	play("rain")
	
	# start the timer so that calling _on_tower_placed works
	effect_duration.start(duration)
	
	# For current towers in the rain area
	var towers := detection_area.get_overlapping_areas()
	print("Towers in rain area: ", towers)
	for tower : Tower in towers:
		_on_tower_placed(tower)
	
	# For future towers in rain area
	PlayerStats.upgraded_tower.connect(_on_tower_upgrade)
	PlayerStats.gtower_placed.connect(_on_tower_placed)
	
	#effect_duration.start(duration)
	effect_duration.timeout.connect(func():
		play("despawn")
		PlayerStats.upgraded_tower.disconnect(_on_tower_upgrade)
		PlayerStats.gtower_placed.disconnect(_on_tower_placed)
		await animation_finished
		queue_free()
	)

func _on_tower_placed(tower : Tower) -> void:
	var _duration = effect_duration.time_left
	#print("duration left: ", effect_duration.time_left)
	#print("duration: ", effect_duration.wait_time)
	var stat_changer = StatChanger.new()
	stat_changer.initialize_variables(tower, "rain", ATK_COOLDOWN, buff_percent, _duration)
	tower.add_child(stat_changer)
	tower.weather_statuses.set("rain", stat_changer)
	
# make note that attackers call this function twice 
# because when you upgrade it, the atk buff gets
# overriden by the upgrade_tower() function
func _on_tower_upgrade(tower : Tower) -> void:
	if is_instance_valid(tower.weather_statuses["rain"]):
		print("atk cd before: ", tower._attack_cooldown.wait_time)
		tower.weather_statuses["rain"].disable_stat_changes(true, false)
		print("atk cd reset: ", tower._attack_cooldown.wait_time)
		tower.weather_statuses.erase("rain")
		var stat_changer = StatChanger.new()
		#tower.level += 1
		stat_changer.initialize_variables(tower, "rain", ATK_COOLDOWN, buff_percent, effect_duration.time_left)
		tower.add_child(stat_changer)
		#tower.level -= 1
		tower.weather_statuses.set("rain", stat_changer)
		print("atk cd after: ", tower._attack_cooldown.wait_time)
		print("-------atk-------")
#func _on_tower_upgrade(tower : Tower) -> void:
	#pass
