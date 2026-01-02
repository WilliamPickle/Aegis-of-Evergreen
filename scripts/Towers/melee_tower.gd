extends Attacker
class_name Melee_Tower

@onready var attack_range = $AttackRange
@onready var attack_shapes = [
	$AttackRange/AttackShape0,
	]

func _physics_process(delta: float) -> void:
	if targeted_enemy != null:
		#attack_range.rotation = (targeted_enemy.global_position).angle_to(global_position)
		attack_range.rotation = (targeted_enemy.global_position - global_position).angle()
		attack_range.rotation += 1
		queue_redraw()

#func _draw() -> void:
	#super._draw()
	
#func update_enemy_list() -> void:
	#var enemies = attack_range.
