extends Attacker
class_name Melee_Tower

const COLOR = Color(0.75,0,0,0.3)

@onready var attack_range : Area2D = $AttackRange
@onready var attack_shapes : Array[CollisionPolygon2D] = [
	$AttackRange/AttackShape0,
	$AttackRange/AttackShape1,
	$AttackRange/AttackShape2,
	]
@onready var shape_polygon = attack_shapes[0].polygon


func _ready():
	super._ready()
	stat_changed.connect(_update_visual)
	#attack_range.attack_shape = attack_shapes[0]
	#attack_range.tower = self

func _draw() -> void:
	if can_draw:
		draw_circle(Vector2.ZERO, range_collider.shape.radius, Color(0.15, 0.15, 0.15, 0.25))
		draw_circle(Vector2.ZERO, range_collider.shape.radius, Color(0.15, 0.15, 0.15, 0.25), false, 2)
		draw_circle(Vector2.ZERO, $BodyCollision.shape.radius, Color(0.15, 0.15, 0.15, 0.25), false, 1.5)
		
		draw_set_transform_matrix(attack_range.transform)
		draw_polygon(shape_polygon,[COLOR])

func attack() -> void:
	if not is_instance_valid(targeted_enemy):
		update_enemy_list()
		return
	sprite.play("attacking_"+str(level))
	var tower_attack : Melee = load(attack_fpath).instantiate()
	tower_attack.global_position = global_position
	#map_area.call_deferred("add_child", tower_attack)
	
	map_area.add_child(tower_attack)
	tower_attack.start(self, attack_range.global_rotation, targeted_enemy, attack_range.get_overlapping_areas())

func upgrade_tower() -> void:
	super.upgrade_tower()
	attack_shapes[level-1].disabled = true
	attack_shapes[level].disabled = false
	shape_polygon = attack_shapes[level].polygon

func _update_visual() -> void:
	var points = attack_shapes[level].polygon
	for point : Vector2 in points:
		point.normalized()

func _physics_process(delta: float) -> void:
	if targeted_enemy != null:
		attack_range.global_rotation = ((targeted_enemy.global_position - global_position) * -1).angle() - PI/2
		if can_draw:
			queue_redraw()
