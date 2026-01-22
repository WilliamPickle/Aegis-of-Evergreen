extends Enemy

@onready var tree = get_tree()
const heal_quantity: int = 5
var boss_present: bool = false
var boss: Enemy

func _ready() -> void:
	super._ready()
	#print("has group?", tree.has_group("boss_minions"))
	if tree.has_group("boss_minions"):
		add_to_group("boss_minions")
	check_for_boss()
	
	
func heal_boss():
	if path.progress_ratio >= 1 or !boss_present or !is_instance_valid(boss):
		return
	#print("Uhh boss is present? ", boss_present)
	boss.cur_health += heal_quantity
	boss.draw_health()
	removed.disconnect(heal_boss)
	

func check_for_boss():
	if tree.has_group("boss") and tree.get_node_count_in_group("boss") > 0:
		#print("nodes in boss: ", tree.get_node_count_in_group("boss"))
		#print("node name: ", tree.get_first_node_in_group("boss").name)
		var boss_list = tree.get_nodes_in_group("boss")
		for enemy in boss_list:
			if enemy.name == "queen_hornet":
				boss_present = true
				boss = enemy
				removed.connect(heal_boss)
