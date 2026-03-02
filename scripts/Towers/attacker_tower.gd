extends Tower
class_name Attacker

## Possible target types.
enum Target{
	FIRST,
	LAST,
	STRONG,
	WEAK,
}
# Attacker only stats
@onready var damage : float = object_data["damage"][level]
@onready var attack_fpath : String = object_data["attack_fpath"][level]

@onready var _attack_cooldown : Timer = $AttackCoolDOwn

var cur_damage : float
# Randomizing the target type for now.
var target_type = Target.FIRST
# Current enemy tower does damage to
var targeted_enemy : Area2D

func _ready() -> void:
	super._ready()
	#_attack_cooldown.wait_time = object_data["attack_speed"][level]
	cur_damage = damage
	_attack_cooldown.timeout.connect(update_enemy_list)
	# Once tower is placed we can start attacking
	tower_placed.connect(on_placement)


func on_placement() -> void:
	_attack_cooldown.autostart = true
	_attack_cooldown.start(object_data["attack_speed"][level])
	super()

# This is to be defined by a sub class
func attack():
	if not is_instance_valid(targeted_enemy):
		print("----------")
		print("NOT VALID!!!!!!!!!")
		update_enemy_list()
		return

	sprite.play("attacking_"+str(level))
	var tower_attack : Projectile = load(attack_fpath).instantiate()
	tower_attack.tower = self
	tower_attack.tower_range = range_area
	tower_attack.target_enemy = targeted_enemy
	tower_attack.global_position = global_position
	map_area.call_deferred("add_child", tower_attack)

# Set the _enemies list to the overlapping areas
# can be removed due to only using _enemies once.
func update_enemy_list() -> void:
	var enemies = range_area.get_overlapping_areas()
	# If tower tried to attack and has no enemies to target
	# Stop the timer and use regular area_entered function
	if enemies.size() == 0:
		print(name," no enmies detected when attacking")
		sprite.play("idle_"+str(level))
		_attack_cooldown.stop()
		range_area.area_entered.connect(first_enemy_entered)
		targeted_enemy = null
		queue_redraw()
	# Set to the corresponding enemy
	else:
		set_target(enemies)
		attack()

func upgrade_tower() -> void:
	super.upgrade_tower()
	sprite.play("idle_"+str(level))
	damage = object_data["damage"][level]
	cur_damage = damage
	attack_fpath = object_data["attack_fpath"][level]
	_attack_cooldown.start(object_data["attack_speed"][level])

## When tower checks for enemies in its range, and detects 0,
## the tower will use defualt area_entered signal.
func first_enemy_entered(enemy : Area2D):
	print("Enemy has entered range")
	# Disable as now there is an enemy to detect
	range_area.area_entered.disconnect(first_enemy_entered)
	targeted_enemy = enemy
	sprite.play("attacking_"+str(level))
	await sprite.animation_finished
	# Cool down already ran previously, so we are okay to
	# perform an immidiate attack. 
	attack()
	
	_attack_cooldown.start()

## Finds and sets the correct enemy to target.
func set_target(enemies : Array[Area2D]) -> void:
	# Place holder
	var _chosen_enemy = enemies[0]
	
	# If/elif would work, but people seem to recommend match
	# statements for these type of scenarios.
	match target_type:
		# For first and last we get the parent and find the
		# lowest/highest progres ratio
		Target.FIRST:
			for enemy in enemies:
				var path_follow : PathFollow2D = enemy.get_parent()
				if path_follow.progress_ratio > _chosen_enemy.get_parent().progress_ratio:
					_chosen_enemy = enemy
		Target.LAST:
			for enemy in enemies:
				var path_follow : PathFollow2D = enemy.get_parent()
				if path_follow.progress_ratio < _chosen_enemy.get_parent().progress_ratio:
					_chosen_enemy = enemy
		Target.STRONG:
			var highest_health : float = -1.0
			for enemy : Enemy in enemies:
				if enemy.cur_health > highest_health:
					_chosen_enemy = enemy
					highest_health = enemy.cur_health
		Target.WEAK:
			var lowest_health : float = enemies[0].cur_health
			for enemy : Enemy in enemies:
				if enemy.cur_health < lowest_health:
					_chosen_enemy = enemy
					lowest_health = enemy.cur_health
	if _chosen_enemy.global_position.x < global_position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
		
	targeted_enemy = _chosen_enemy
