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
	
func apply_stat_changes(target, stat, percent_change, duration):
	# make sure same debuffs/buffs from same enemy type aren't repeated
	for status in target.status_applied_list:
		if status == target.name:
			print("tried to apply and failed bozo")
			return
			
	# innitiate timer
	var status_timer = Timer.new()
	target.add_child(status_timer)
	status_timer.timeout.connect(disable_stat_changes.bind(target, stat, status_timer))
	status_timer.wait_time = duration
	status_timer.start()
	target.status_applied_list.append(target.name)

	# the actual stat changing part
	match stat:
		Type.WALK_SPEED:
			target.speed = target.speed * percent_change
		Type.ATK_COOLDOWN:
			target._attack_cooldown.wait_time = target._attack_cooldown.wait_time * percent_change 
			

func disable_stat_changes(target, stat, status_timer):
	match stat:
		Type.WALK_SPEED:
			target.speed = target.enemy_data["speed"]
		Type.ATK_COOLDOWN:
			target._attack_cooldown.wait_time = target.object_data["attack_speed"][target.level]
			
	for i in range(len(target.status_applied_list)):
		if target.status_applied_list[i] == target.name:
			target.status_applied_list.pop_at(i) 
	status_timer.queue_free()
	print("timer ended")
