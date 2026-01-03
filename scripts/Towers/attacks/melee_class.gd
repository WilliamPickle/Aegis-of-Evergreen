extends AnimatedSprite2D
class_name Melee

@onready var splash_cap : int = 6

func start(start_rotation : float, target_enemy : Enemy, enemies : Array[Area2D]) -> void:
	global_rotation = start_rotation - PI/2
	play("default")
	target_enemy.apply_damage(2, Projectile.Type.BLUNT)
	enemies.erase(target_enemy)

	for i in range(splash_cap):
		if enemies.size() > 0:
			var ran_index : int = randi() % enemies.size()
			var chosen_enemy : Enemy = enemies.pop_at(ran_index)
			chosen_enemy.apply_damage(2, Projectile.Type.BLUNT)
		else:
			break
	animation_finished.connect(func():
		queue_free()
		)
