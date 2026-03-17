extends industrial_enemy

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var discharge: AnimatedSprite2D = $discharge
@onready var discharge_area: Area2D = $discharge_area
@onready var timer: Timer = $Timer
const phase_change_percent : Array[float] = [0.75, 0.25]
const phase_speed : Array[float] = [0.5, 1]
const stun_duration : Array[float] = [2, 3]
const stun_cd : Array[float] = [4, 2]
const stun_scale : Array[Vector2] = [Vector2(1, 1), Vector2(1.5, 1.5)]
const stun_radius : Array[float] = [75, 100]
var cur_phase : int = 1

func apply_damage(damage : float, damage_type):
	super.apply_damage(damage, damage_type)
	if cur_health <= max_health * phase_change_percent[1] and cur_phase < 3:
		change_phase()
	if cur_health <= max_health * phase_change_percent[0] and cur_phase < 2:
		change_phase()
		timer.timeout.connect(spawn_discharge)
		
func change_phase() -> void:
	speed_variance = -1
	cur_phase += 1
	#max_health = phase_health[cur_phase - 2]
	#cur_health = max_health
	
	# transform and discharge
	sprite.play("phase" + str(cur_phase) + "t")
	sprite.frame_changed.connect(apply_discharge.bind(6))
	await sprite.animation_finished
	sprite.frame_changed.disconnect(apply_discharge)
	sprite.play("phase"  + str(cur_phase))
	
	# setup phase stats
	speed_variance = phase_speed[cur_phase - 2]
	discharge_area.get_child(0).shape.radius = stun_radius[cur_phase - 2]
	discharge_area.scale = stun_scale[cur_phase - 2]
	timer.start(stun_cd[cur_phase - 2])

func spawn_oil() -> void:
	super.spawn_oil()
	new_oil.scale = Vector2(1.5, 1.5)

func apply_discharge(frame: float = 0) -> void:
	if frame == 0:
		frame = sprite.frame
	if !frame == sprite.frame:
		return
	
	var target_list = discharge_area.get_overlapping_areas()
	for tower in target_list:
		var stat_changer = StatChanger.new()
		stat_changer.initialize_variables(tower, "atlas", StatChanger.Type.ATK_COOLDOWN, 5, stun_duration[cur_phase - 2])
		tower.add_child(stat_changer)


func spawn_discharge() -> void:
	discharge.visible = true
	discharge.play("default")
	discharge.frame_changed.connect(apply_discharge.bind(6))
	await discharge.animation_finished
	discharge.frame_changed.disconnect(apply_discharge)
	discharge.visible = false
