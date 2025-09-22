extends Area2D
var front_sprite_speed = 8
var mid_sprite_speed = 10
var back_sprite_speed = 14


var front1_tween = create_tween().set_loops()
var front2_tween = create_tween().set_loops()
var mid1_tween = create_tween().set_loops()
var mid2_tween = create_tween().set_loops()
var back1_tween = create_tween().set_loops()
var back2_tween = create_tween().set_loops()




func _ready():
	front1_tween.tween_property($tree_front,"position",Vector2(160,0),front_sprite_speed)
	front1_tween.tween_property($tree_front,"position",Vector2(0,0),0)
	front2_tween.tween_property($tree_front2,"position",Vector2(0,0),front_sprite_speed)
	front2_tween.tween_property($tree_front2,"position",Vector2(-160,0),0)
	
	mid1_tween.tween_property($tree_mid,"position",Vector2(160,0),mid_sprite_speed)
	mid1_tween.tween_property($tree_mid,"position",Vector2(0,0),0)
	mid2_tween.tween_property($tree_mid2,"position",Vector2(0,0),mid_sprite_speed)
	mid2_tween.tween_property($tree_mid2,"position",Vector2(-160,0),0)
	
	back1_tween.tween_property($tree_back,"position",Vector2(160,0),back_sprite_speed)
	back1_tween.tween_property($tree_back,"position",Vector2(0,0),0)
	back2_tween.tween_property($tree_back2,"position",Vector2(0,0),back_sprite_speed)
	back2_tween.tween_property($tree_back2,"position",Vector2(-160,0),0)
