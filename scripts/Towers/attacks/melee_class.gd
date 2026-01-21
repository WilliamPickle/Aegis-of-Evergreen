extends AnimatedSprite2D
class_name Melee

static var Game_Data = JSON.parse_string(FileAccess.get_file_as_string("res://Game Data.json"))
@export var data_resource : DataResource = DataResource.new()
@onready var object_data = Game_Data[data_resource.class_type][data_resource.object]
@onready var splash_cap = object_data["splash_cap"]
@onready var type = object_data["type"]

func start(tower : Attacker, start_rotation : float, target_enemy : Enemy, enemies : Array[Area2D]) -> void:
	global_rotation = start_rotation - PI/2
	play("default")
	target_enemy.apply_damage(tower.cur_damage, type)
	enemies.erase(target_enemy)

	for i in range(splash_cap):
		if len(enemies) > 0:
			var ran_index : int = randi() % enemies.size()
			var chosen_enemy : Enemy = enemies.pop_at(ran_index)
			chosen_enemy.apply_damage(tower.cur_damage, type)
		else:
			break
	animation_finished.connect(func():
		queue_free()
		)
