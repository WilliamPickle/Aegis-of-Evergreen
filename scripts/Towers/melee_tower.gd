extends Attacker
class_name Melee_Tower

@onready var attack_range = $AttackRange
@onready var attack_shapes = [
	$AttackRange/AttackShape0,
	]

func _physics_process(delta: float) -> void:
	if targeted_enemy != null:
		#attack_range.rotation = 
		queue_redraw()

#func _draw() -> void:
	#super._draw()
	
#func update_enemy_list() -> void:
	#var enemies = attack_range.
