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

@onready var target
@onready var inflictor: String
@onready var stat
#ex: 0.25 indicates stat is 25% better (thus 125% of original)
#ex: -0.25 indicates stat is 25% worse (thus 75% of orginal)
@onready var percent_change: float
@onready var duration: float

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
			target.speed = target.speed * (1 + percent_change)
		Type.ATK_COOLDOWN:
			target._attack_cooldown.wait_time = target._attack_cooldown.wait_time * (1 + percent_change) 
		Type.RANGE:
			target.range_collider.shape.radius = target.range_collider.shape.radius * (1 + percent_change)
			target.queue_redraw()
		Type.DOT:
			timeout.disconnect(disable_stat_changes)
			for i in range(duration):
				start(DOT_TICK_RATE)
				await timeout
				target.apply_damage(percent_change, "blunt")
			disable_stat_changes()
		Type.MONEY_MULT:
			target.money_drop *= 1 + percent_change
			

func disable_stat_changes(delete_timer : bool = true):
	match stat:
		Type.WALK_SPEED:
			target.speed = target.original_speed
		Type.ATK_COOLDOWN:
			target._attack_cooldown.wait_time = target.object_data["attack_speed"][target.level]
		Type.RANGE:
			target.range_collider.shape.radius = target.range
			target.queue_redraw()
		Type.MONEY_MULT:
			target.money_drop = target.enemy_data["money_drop"]
	
	
			
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
