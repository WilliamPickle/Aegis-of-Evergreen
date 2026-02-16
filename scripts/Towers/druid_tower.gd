extends Attacker
class_name Druid

static var random := RandomNumberGenerator.new()
static var does_exist := false
#var paths : Array[Path2D]
## 2D array holding each paths points
var points_list : Array[Vector2]
## 2D array that hold the bounds
var target_points : Array[Vector2]


func _ready() -> void:
	super()
	is_hero = true
	random.randomize()
	var paths = get_tree().get_nodes_in_group("enemy_path")
	
	for path : Path2D in paths:
		var curve := path.curve
		for point in curve.get_baked_points():
			points_list.append(point)
		#for i in curve.point_count:
			#points_list.append(curve.get_point_position(i))
	
	print("Len of paths: ",len(paths))
	print("Len of points list: ",len(points_list))

func on_placement():
	super()
	does_exist = true
	calculate_points()
	#if target_points.size() == 0:
		#print("NO POINTS TO REGISTER FOR TARGETTING")
		#_attack_cooldown.paused = true
	
func update_enemy_list() -> void:
	var enemies = range_area.get_overlapping_areas()
	if len(target_points) == 0:
		print("NO PATH NEAR")
		return
	elif enemies.size() == 0:
		var i = random.randi() % target_points.size()
		attack(target_points[i], false)
	else:
		set_target(enemies)
		attack(targeted_enemy.global_position)

func place_tower() -> bool:
	if get_overlapping_areas().size() > 0:
		var notif := Error_Notification.new()
		map_area.add_child(notif)
		notif.send_notif(global_position,"can't place here")
		return false

	if does_exist:
		Tower_Placement.reset_data(true)
		var notif = Error_Notification.new()
		map_area.add_child(notif)
		notif.send_notif(global_position,"max of 1 druid")
		return false

	if !PlayerStats.purchase_item(cost):
		Tower_Placement.reset_data(true)
		var notif := Error_Notification.new()
		map_area.add_child(notif)
		notif.send_notif(global_position,"not enough funds")
		return true
	
	disable_placement()
	
	return true

func calculate_points() -> void:
	var center := global_position
	for point in points_list:
		var magnitude = (point - center).length()
		if magnitude <= range and !(point in target_points):
			target_points.append(point)

func attack(pos : Vector2 = Vector2.ZERO, target_enemy : bool = true):
	if target_enemy and not is_instance_valid(targeted_enemy):
		print("----------")
		print("NOT VALID!!!!!!!!!")
		update_enemy_list()
		return
	sprite.play("attacking")
	var tower_attack : Trap = load(attack_fpath).instantiate()
	tower_attack.tower = self
	tower_attack.global_position = pos
	map_area.call_deferred("add_child", tower_attack)
	await sprite.animation_finished
	sprite.play("idle_0")

func upgrade_tower() -> void:
	super()
	calculate_points()
