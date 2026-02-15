extends Melee_Tower
var slow_debuff_percent: float
var slow_debuff_duration: float

func attack() -> void:
	if not is_instance_valid(targeted_enemy):
		update_enemy_list()
		return
	sprite.play("attacking_"+str(level))
	var tower_attack : Melee = load(attack_fpath).instantiate()
	tower_attack.global_position = global_position
	#map_area.call_deferred("add_child", tower_attack)
	
	map_area.add_child(tower_attack)
	tower_attack.start(self, attack_range.global_rotation, targeted_enemy, attack_range.get_overlapping_areas(), StatChanger.Type.WALK_SPEED)
