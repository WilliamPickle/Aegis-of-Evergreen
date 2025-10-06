extends Area2D

@onready var click_title_text : Label = self.get_node('/root/current_scene/menu_screen/menu_text/start_title_shadow')
@onready var splash_text : Label = self.get_node('/root/current_scene/menu_screen/menu_text/splash_text')
@onready var sprite_layers = {
	1 : $tree1,
	2 : $tree2,
	3 : $sky,
}

var date = Time.get_datetime_dict_from_system()
var splash_text_options = {
	0 : "game good!",
	1 : "10/1/25",
	2 : "p!z v0t3",
	3 : "lick game",
	4 : str(date.month) + "/" + str(date.day) + "/" + str(date.year),
}
var layer_speed = {
	1 : 12,
	2 : 6,
	3 : 2,
}

var start_pos_x = -160;

func _ready() -> void:
	## Code for splash text at the start of the game.
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var ran_index = rng.randi() % splash_text_options.size()
	splash_text.text = splash_text_options[ran_index]

func _physics_process(delta) -> void:
	for layer in sprite_layers:
		if sprite_layers[layer].position.x >= start_pos_x * -1:
			sprite_layers[layer].position.x = start_pos_x;
		else:
			sprite_layers[layer].position.x += layer_speed[layer] * delta;

# Temp code to be changed later
func _on_button_button_down() -> void:
	$Button.queue_free()
	click_title_text.queue_free()
	$Icons.visible = true
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property($Icons,"position",Vector2(0,0),0.25)
