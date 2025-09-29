extends Area2D

@onready var sprite_layers = {
	1 : $tree1,
	2 : $tree2,
	3 : $sky,
}

var layer_speed = {
	1 : 12,
	2 : 6,
	3 : 2,
}

var start_pos_x = -160;
	
func _physics_process(delta) -> void:
	for layer in sprite_layers:
		if sprite_layers[layer].position.x >= start_pos_x * -1:
			sprite_layers[layer].position.x = start_pos_x;
		else:
			sprite_layers[layer].position.x += layer_speed[layer] * delta;

# Temp code to be changed later
func _on_button_button_down() -> void:
	#SceneLoader.quick_add_scene("res://scenes/test_scene.tscn","test_scene","start_menu")
	SceneLoader.load_scene("res://scenes/test_scene.tscn", "test_scene");
	SceneLoader.disable_scene("start_menu", true);
	print("Clicked!!!!")
