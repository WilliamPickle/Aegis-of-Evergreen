extends Enemy

const total_spores : int = 5
var spores_left : int = total_spores
var prev_frame : int = 0

func apply_damage(damage : float, damage_type):
	super.apply_damage(damage, damage_type)
	if cur_health < max_health * 1 and spores_left >= 5:
		spawn_spore()
		print("spore 1")
	if cur_health <= max_health * .80 and spores_left >= 4:
		spawn_spore()
		print("spore 2")
	if cur_health <= max_health * .60 and spores_left >= 3:
		spawn_spore()
		print("spore 3")
	if cur_health <= max_health * .40 and spores_left >= 2:
		spawn_spore()
		print("spore 4")
	if cur_health <= max_health * .20 and spores_left >= 1:
		spawn_spore()
		print("spore 5")
		
		
		
func spawn_spore():
	spores_left -= 1
	print("tried to spawn a spore:", total_spores - spores_left)
	prev_frame = enemy_sprite.frame
	enemy_sprite.play(str(spores_left) + " spore")
	enemy_sprite.frame = prev_frame
	
	var sprite : AnimatedSprite2D
