extends WaveSpawner

@onready var lvl8_dialogue: DialogueBox = $"../DialogueUI/DialogueBox"
@onready var manual_wave_button: Button = $"../Start Button/MarginContainer/VBoxContainer/HBoxContainer/StartWave"
@onready var path2: Path2D = $"../EnemyPath2"
@onready var path3: Path2D = $"../EnemyPath3"
@onready var path4: Path2D = $"../EnemyPath4"

func _ready() -> void:
	super._ready()
	wave_bonus_money = [0, 100, 125, 150, 175]
	lvl8_dialogue.start_wave.connect(_on_start_lvl8)
	manual_wave_button.button_down.connect(_on_start_lvl8)
	Tower.update_min_max_pos(Vector2(-320, -280), Vector2(420, 180))

func _on_start_lvl8() -> void:
	# wave 1
	start_wave_timer(60)
	WeatherController.spawn_rotting_grass(90, -0.25, weather_node)
	await delay(3)
	send_enemy(spore, 1, 2, path2)
	send_enemy(hornet, 3, 3)
	await delay(0.5)
	await send_enemy(hornet, 3, 3)
	send_enemy(spore, 1, 2, path2)
	send_enemy(hornet, 3, 3, path3)
	await delay(0.5)
	await send_enemy(hornet, 3, 3, path3)
	
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 2
	start_wave_timer(45)
	WeatherController.spawn_wind(5, 0.25, -0.25, 1, weather_node, true, Vector2(420, 180), Vector2(-320, -280))
	await send_enemy(cow, 2, 1, path3)
	await delay(10)
	await send_enemy(tree_cutter, 3, 4, path4)
	
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()

	# wave 3
	start_wave_timer(20)
	WeatherController.spawn_trash_wind(60, 20, 1, Vector2(-320, -280), Vector2(420, 180), weather_node)
	WeatherController.spawn_wind(45, 0.35, -0.35, 1, weather_node, false, Vector2(420, 180), Vector2(-320, -280))
	send_enemy(snail, 5, 2)
	await send_enemy(cow, 5, 2, path3)
	
	
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()

	# wave 4
	start_wave_timer(75)
	WeatherController.spawn_harsh_sun(60, -0.25, weather_node)
	await send_enemy(tree_cutter, 7, 2, path4)
	await send_enemy(armor_mushroom, 20, 0.5, path2, -0.5)
	await delay(8)
	await send_enemy(tree_cutter, 7, 2, path4)

	
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
#
	# wave 5
	start_wave_timer(3600)
	await send_enemy(tanky_mushroom, 3, 3, path2)
	await send_enemy(amalgamushroom, 1, 1, path2)
	send_enemy(spore_crab, 5, 5, path2)
	await delay(45)
	await send_enemy(beetle, 8, 1, path3, -0.5)
	await send_enemy(tree_cutter, 20, 0.5, path4, -0.5)
	await delay(10)
	await send_enemy(beetle, 10, 1, path3, -0.5)
	await send_enemy(tree_cutter, 20, 0.5, path4, -0.5)
	await delay(15)
	WeatherController.spawn_wind(30, 0.5, -0.35, 1, weather_node, true, Vector2(420, 180), Vector2(-320, -280))
	await send_enemy(tree_cutter, 12, 0.5, path4)
	await delay(15)
	await send_enemy(beetle, 10, 1, path3, -0.5)
	await send_enemy(tree_cutter, 20, 0.5, path4, -0.5)
	WeatherController.spawn_wind(30, 1, -0.35, 1, weather_node, true, Vector2(420, 180), Vector2(-320, -280))

	
	
	currently_sending = false
	await wave_timer.timeout
