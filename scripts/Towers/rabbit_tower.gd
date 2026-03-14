extends Attacker

func attack():
	if not is_instance_valid(targeted_enemy):
		print("----------")
		print("NOT VALID!!!!!!!!!")
		update_enemy_list()
		return
	print("RABBIT ATTACKED!!!!!!!-----------")
