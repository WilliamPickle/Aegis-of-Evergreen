extends Area2D

@onready var sprite_layers = {
	1 : $tree1,
	2 : $tree2,
	3 : $tree3,
}

var layer_speed = {
	1 : 10,
	2 : 7,
	3 : 4,
}

var start_pos_x = -80;

func _process(delta) -> void:
	for layer in sprite_layers:
		if sprite_layers[layer].position.x >= start_pos_x * -1:
			sprite_layers[layer].position.x = start_pos_x;
		else:
			sprite_layers[layer].position.x += layer_speed[layer] * delta;
