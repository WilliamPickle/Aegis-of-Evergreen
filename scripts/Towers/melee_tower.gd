extends Attacker
class_name Melee_Tower

signal test
const COLOR = Color(0.75,0,0,0.3)

@onready var attack_range : Area2D = $AttackRange
@onready var attack_shapes : Array[CollisionPolygon2D] = [
	$AttackRange/AttackShape0,
	]


func _ready():
	super._ready()
	#attack_range.attack_shape = attack_shapes[0]
	#attack_range.tower = self

func _draw() -> void:
	super._draw()
	if can_draw:
		draw_set_transform_matrix(attack_range.transform)
		draw_polygon(attack_shapes[level].polygon,[COLOR])

func attack() -> void:
	if not is_instance_valid(targeted_enemy):
		print("----------")
		print("NOT VALID!!!!!!!!!")
		update_enemy_list()
		return
	sprite.play("attacking_"+str(level))
	var tower_attack : Melee = load(attack_fpath).instantiate()
	tower_attack.global_position = global_position
	#map_area.call_deferred("add_child", tower_attack)
	map_area.add_child(tower_attack)
	tower_attack.start(attack_range.global_rotation, targeted_enemy, attack_range.get_overlapping_areas())

func _physics_process(delta: float) -> void:
	if targeted_enemy != null:
		attack_range.global_rotation = ((targeted_enemy.global_position - global_position) * -1).angle() - PI/2
		if can_draw:
			queue_redraw()
