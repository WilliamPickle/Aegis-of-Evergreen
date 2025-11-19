extends Attacker
class_name Basic


func test(attack : Projectile):
	attack.tower_area = range_area
	attack.target_enemy = targeted_enemy

func attack():
	var tower_attack : Projectile = load("res://scenes/Towers/attacks/chipmunk_projectile_1.tscn").instantiate()
	tower_attack.tower_area = range_area
	tower_attack.target_enemy = targeted_enemy
	#call_deferred("test")
	#map_area.add_child(tower_attack)
	map_area.call_deferred("add_child", tower_attack)
