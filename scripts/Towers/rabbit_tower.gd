extends Attacker

@onready var stun_duration : float = object_data["stun_duration"][level]
@onready var stun_cap : int = object_data["stun_cap"][level]

func attack():
	if not is_instance_valid(targeted_enemy):
		print("----------")
		print("NOT VALID!!!!!!!!!")
		update_enemy_list()
		return
	print("RABBIT ATTACKED!!!!!!!-----------")

func upgrade_tower():
	pass
