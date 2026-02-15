extends Timer
class_name StatChanger

enum Type{
	NONE,
	ATK_COOLDOWN,
	RANGE,
	DAMAGE,
	WALK_SPEED,
	BLUNT_RES,
	ENERGY_RES, 
	MONEY_DROP,
	DOT,
}
const DOT_TIME : float = 0.5

@onready var target
@onready var inflictor: String
@onready var stat
#ex: 0.25 indicates stat is 25% better (thus 125% of original)
#ex: -0.25 indicates stat is 25% worse (thus 75% of orginal)
@onready var percent_change: float
@onready var duration: float

func _ready() -> void:
	self.apply_stat_changes()
			
func apply_stat_changes():
	var timer = self
	# make sure same debuffs/buffs from same enemy type aren't repeated
	for status in target.status_applied_list:
		if status == inflictor:
			#print("tried to apply and failed bozo")
			timer.queue_free()
			return
			
	# innitiate timer
	timer.timeout.connect(disable_stat_changes.bind(timer))
	#timer.wait_time = durationF
	#timer.one_shot = true
	#timer.start()
	start(duration)
	target.status_applied_list.append(inflictor)

	# the actual stat changing part
	match stat:
		Type.WALK_SPEED:
			target.speed = target.speed * (1 + percent_change)
		Type.ATK_COOLDOWN:
			target._attack_cooldown.wait_time = target._attack_cooldown.wait_time * (1 + percent_change) 
		Type.RANGE:
			target.range_collider.shape.radius = target.range_collider.shape.radius * (1 + percent_change)
		Type.DOT:
			timeout.disconnect(disable_stat_changes)
			for i in range(duration):
				start(DOT_TIME)
				await timeout
				target.apply_damage(percent_change, "blunt")
			disable_stat_changes(timer)
			

func disable_stat_changes(timer):
	match stat:
		Type.WALK_SPEED:
			target.speed = target.original_speed
		Type.ATK_COOLDOWN:
			target._attack_cooldown.wait_time = target.object_data["attack_speed"][target.level]
		Type.RANGE:
			target.range_collider.shape.radius = target.range
	
	
	for _inflictor in target.status_applied_list:
		if _inflictor == inflictor:
			target.status_applied_list.erase(_inflictor)
			
	#print("timer ended")
	timer.queue_free()
	

func initialize_variables(new_target, new_inflictor: String, new_stat, new_percent_change: float, new_duration: float) -> void:
	target = new_target
	inflictor = new_inflictor
	stat = new_stat
	percent_change = new_percent_change
	duration = new_duration
