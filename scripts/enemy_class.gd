class_name Enemy
extends Node2D

# Variables you need to assign
var enemy_sprite : Node2D
var path : PathFollow2D

# values and attributes
var path_position = null
@export var speed = 0.02
var cur_position = 0
var prev_position = 0

func move_on_path(delta) -> void:
	path_position = path.get_global_position().x
	prev_position = cur_position
	path.progress_ratio += speed * delta
	cur_position = path_position
	
	if (cur_position - prev_position < 0):
		enemy_sprite.flip_h = false
	else:
		enemy_sprite.flip_h = true
