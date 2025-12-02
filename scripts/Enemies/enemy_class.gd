class_name Enemy
extends Area2D

@export var enemy_sprite : Node2D
@export var enemy_node : Node2D
@export var speed = 0.02

# values and attributes
var path : PathFollow2D
var path_position = null
var cur_position = 0
var prev_position = 0

func _ready() -> void:
	# Initialize path
	path = enemy_node.get_parent()
	
# progresses enemy along a path.
# automatically deletes enemy and path when it reaches the end
func move_on_path(delta) -> void:
	if  path.progress_ratio >= 1:
		path.queue_free()
		enemy_sprite.queue_free()

	path_position = path.get_global_position().x
	prev_position = cur_position
	path.progress_ratio += speed * delta
	cur_position = path_position
	
	if (cur_position - prev_position < 0):
		enemy_sprite.flip_h = false
	else:
		enemy_sprite.flip_h = true

func _process(delta: float) -> void:
	move_on_path(delta)
