extends Attacker

const WALK_SPEED := StatChanger.Type.WALK_SPEED
const BASE_SPEED : float = 0.015

@onready var stun_duration : float = object_data["stun_duration"][level]
@onready var stun_cap : int = object_data["stun_cap"][level]

var rand = RandomNumberGenerator.new()

func attack():
	if not is_instance_valid(targeted_enemy):
		print("----------")
		print("NOT VALID!!!!!!!!!")
		update_enemy_list()
		return
	sprite.play("attacking_"+str(level))
	await sprite.animation_finished
	sprite.play("idle_"+str(level)) # Remove this maybe???
	var enemies := range_area.get_overlapping_areas()
	if enemies.size() == 0:
		return
	set_target(enemies)
	_damage_enemy(targeted_enemy)
	enemies.erase(targeted_enemy)
	var enemies_to_dmg : int = stun_cap-1 if stun_cap <= enemies.size() else enemies.size()
	for i in range(enemies_to_dmg):
		var rand_i = rand.randi_range(0, enemies.size()-1)
		var enemy = enemies[rand_i]
		_damage_enemy(enemy)
		enemies.erase(enemy)

func update_enemy_list() -> void:
	var enemies = range_area.get_overlapping_areas()
	if enemies.size() == 0:
		print(name," no enmies detected when attacking")
		sprite.play("idle_"+str(level))
		_attack_cooldown.stop()
		range_area.area_entered.connect(first_enemy_entered)
		targeted_enemy = null
		queue_redraw()
	else:
		targeted_enemy = enemies[0]
		attack()

func first_enemy_entered(enemy : Area2D):
	print("Enemy has entered range")
	range_area.area_entered.disconnect(first_enemy_entered)
	targeted_enemy = enemy
	attack()
	_attack_cooldown.start()

func _damage_enemy(enemy : Enemy) -> void:
	if is_instance_valid(enemy):
		var stat_changer := StatChanger.new()
		var new_duration = _calculate_duration(enemy.speed)
		print("New duration for ", enemy.name, ": ", new_duration)
		stat_changer.initialize_variables(enemy, "Rabbit", WALK_SPEED, -1, new_duration)
		enemy.add_child(stat_changer)
		enemy.apply_damage(cur_damage,"blunt")

func _calculate_duration(speed : float) -> float:
	# If its an enemy that is already stunned
	if speed == 0:
		return 100.0  # Huge number to tell if it actually got applied to enemy
	
	var new_duration := stun_duration
	var new_speed = BASE_SPEED/speed # The s/s1 or s/s2 on the desmos screenshot
	if new_speed < 1: # If enenmy faster than bush
		# Increase duration by x%
		new_duration *= 1 + (1 - new_speed) / 2.0  # 1 + (1- (s/s1))/2
		#DESMOS EQUATION: 1 + (1-(0.015/x))/2 {0.015 <= x}
	elif new_speed > 1: # If enemy is slower than bus
		# Keep x% of duration
		# The pow must not be greater 0.25
		new_duration *= 2 - pow(new_speed, 0.2) # 2 - (s/s2)^(1/5)
		#DESMOS EQUATION: 2-(0.015/x)^(1/5) {0.001 <= x <= 0.015}
		
	return new_duration

func upgrade_tower():
	super()
	stun_duration = object_data["stun_duration"][level]
	stun_cap = object_data["stun_cap"][level]
