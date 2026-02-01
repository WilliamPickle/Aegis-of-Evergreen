extends Attacker
class_name Druid

var paths : Array[Path2D]
var points_list : Array[Vector2]
var selected_points : Array[Vector2]

func _ready() -> void:
	super()
	for path in get_tree().get_nodes_in_group("enemy_path"):
		paths.append(path)
	
	var center : Vector2 = global_position
	# DEELTE THIS LATER!!!!
	var time = Time.get_ticks_usec()
	for i in len(paths):
		var sub_array : Array[Vector2]
		for j in paths[i].curve.point_count:
			var point := paths[i].curve.get_point_position(j)
			sub_array.append(point)
		points_list.append_array(sub_array)
	print("Took: ", Time.get_ticks_usec() - time)

func on_placement():
	super()
	calculate_points()
	
func calculate_points():
	var center := global_position
	for point : Vector2 in points_list:
		var magnitude = (point-center).length()
		if magnitude <= range:
			selected_points.append(point)
	queue_redraw()

func _draw() -> void:
	super()
	for point in selected_points:
		draw_circle(point - global_position,3,Color(1,1,1))
