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
	MONEY_DROP
}

@onready var target
@onready var inflictor: String
@onready var stat
@onready var percent_change: float
@onready var duration: float

func _ready() -> void:
	self.apply_stat_changes()
			
func apply_stat_changes():
	var timer = self
	# make sure same debuffs/buffs from same enemy type aren't repeated
	for status in target.status_applied_list:
		if status == inflictor:
			print("tried to apply and failed bozo")
			timer.queue_free()
			return
			
	# innitiate timer
	timer.timeout.connect(disable_stat_changes.bind(timer))
	timer.wait_time = duration
	#timer.one_shot = true
	timer.start()
	target.status_applied_list.append(inflictor)

	# the actual stat changing part
	match stat:
		Type.WALK_SPEED:
			target.speed = target.speed * percent_change
		Type.ATK_COOLDOWN:
			target._attack_cooldown.wait_time = target._attack_cooldown.wait_time * percent_change 
			

func disable_stat_changes(timer):
	match stat:
		Type.WALK_SPEED:
			target.speed = target.enemy_data["speed"]
		Type.ATK_COOLDOWN:
			target._attack_cooldown.wait_time = target.object_data["attack_speed"][target.level]
			
	for i in range(len(target.status_applied_list)):
		if target.status_applied_list[i] == inflictor:
			target.status_applied_list.pop_at(i) 
	print("timer ended")
	timer.queue_free()
	

func initialize_variables(new_target, new_inflictor: String, new_stat, new_percent_change: float, new_duration: float) -> void:
	target = new_target
	inflictor = new_inflictor
	stat = new_stat
	percent_change = new_percent_change
	duration = new_duration
