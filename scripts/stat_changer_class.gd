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
	MONEY_MULT,
	DOT,
}
const DOT_TICK_RATE : float = 0.5

#general variables for every instance of stat_changer
@onready var target
@onready var inflictor: String
@onready var stat
#ex: 0.25 indicates stat is 25% better (thus 125% of original)
#ex: -0.25 indicates stat is 25% worse (thus 75% of orginal)
@onready var percent_change: float
@onready var duration: float
# this is the value added/subtracted after a buff is applied/unapplied
var initial_value: float
var change_value: float

#flower tower based vars
var _is_debuff : bool
var _has_clensed : bool = false

func _ready() -> void:
	self.apply_stat_changes()
			
func apply_stat_changes(is_creating := true):
	if is_creating:
		# If tower is a hero then dont apply debuff
		if _is_debuff and target is Tower and target.is_hero:
			queue_free()
			return
		#var timer = self
		
		# make sure target isn't immune to the debuff/buff
		if target.object_data.has("immunities"):
			for immunity in target.object_data["immunities"]:
				if immunity == stat:
					print(target, " is immune to:", stat)
					queue_free()
					return
				else:
					print(target, " is not immune to: ", stat)
		
		# make sure same debuffs/buffs from same enemy type aren't repeated
		for status in target.status_applied_list:
			if status == inflictor:
				#print("tried to apply and failed bozo")
				queue_free()
				return
				
				
		# innitiate timer
		timeout.connect(disable_stat_changes)
		#timer.wait_time = durationF
		#timer.one_shot = true
		#timer.start()
		start(duration)
		target.status_applied_list.append(inflictor)

	# the actual stat changing part
	match stat:
		Type.WALK_SPEED:
			initial_value = target.speed
			target.speed = target.speed * (1 + percent_change)
			change_value = target.speed - initial_value
		Type.ATK_COOLDOWN:
			#target._attack_cooldown.wait_time += target.object_data["attack_speed"][target.level] * (percent_change)
			initial_value = target._attack_cooldown.wait_time
			target._attack_cooldown.wait_time = target._attack_cooldown.wait_time * (1 + percent_change) 
			change_value = target._attack_cooldown.wait_time - initial_value
			#print("atk cd change: ", change_value, " ||| ", inflictor)
		Type.RANGE:
			initial_value = target.range_collider.shape.radius
			target.range_collider.shape.radius = target.range_collider.shape.radius * (1 + percent_change)
			change_value = target.range_collider.shape.radius - initial_value
			target.queue_redraw()
		Type.DOT:
			timeout.disconnect(disable_stat_changes)
			for i in range(duration):
				start(DOT_TICK_RATE)
				await timeout
				target.apply_damage(percent_change, "blunt")
			disable_stat_changes()
		Type.MONEY_MULT:
			initial_value = target.money_drop
			target.money_drop *= 1 + percent_change
			change_value = target.money - initial_value
			

#lowkey this should probably become 2 separate functions
func disable_stat_changes(delete_timer : bool = true, reset_stat : bool = true):
	if reset_stat:
		match stat:
			Type.WALK_SPEED:
				target.speed -= change_value
			Type.ATK_COOLDOWN:
				target._attack_cooldown.wait_time -= change_value
			Type.RANGE:
				target.range_collider.shape.radius -= change_value
				target.queue_redraw()
			Type.MONEY_MULT:
				target.money_drop -= change_value
	
	
			
	#print("timer ended")
	if delete_timer:
		for _inflictor in target.status_applied_list:
			if _inflictor == inflictor:
				target.status_applied_list.erase(_inflictor)
		queue_free()
	
func update_stat_multiplier(percent_change_change : float) -> void:
	#if _is_debuff and not _has_clensed and target is Tower:
		#_has_clensed = true
		#disable_stat_changes(false)
		#percent_change *= (1 + percent_change_change)
		#apply_stat_changes(false)
	#elif target is Enemy:
		#disable_stat_changes(false)
		#percent_change *= (1 + percent_change_change)
		#apply_stat_changes(false)
	disable_stat_changes(false)
	percent_change *= (1 + percent_change_change)
	apply_stat_changes(false)

## Set the default values for stat_changer. [br]
## [b] Make sure to set [param is_debuff] to [code]true[/code] if an enemy is inflincting a tower[/b]
func initialize_variables(new_target, new_inflictor: String, new_stat : Type, new_percent_change: float, new_duration: float, is_debuff : bool = false) -> void:
	target = new_target
	inflictor = new_inflictor
	stat = new_stat
	percent_change = new_percent_change
	duration = new_duration
	_is_debuff = is_debuff
