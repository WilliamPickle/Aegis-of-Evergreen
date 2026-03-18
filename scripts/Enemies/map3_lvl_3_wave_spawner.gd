extends WaveSpawner

@onready var lvl9_dialogue: DialogueBox = $"../DialogueUI/DialogueBox"
@onready var manual_wave_button: Button = $"../Start Button/MarginContainer/VBoxContainer/HBoxContainer/StartWave"
@onready var path2: Path2D = $"../EnemyPath2"
@onready var path3: Path2D = $"../EnemyPath3"
@onready var path4: Path2D = $"../EnemyPath4"

func _ready() -> void:
	super._ready()
	wave_bonus_money = [0, 100, 125, 150, 250]
	lvl9_dialogue.start_wave.connect(_on_start_lvl9)
	manual_wave_button.button_down.connect(_on_start_lvl9)
	Tower.update_min_max_pos(Vector2(-320, -280), Vector2(420, 180))

func _on_start_lvl9() -> void:
	# wave 1
	start_wave_timer(75)
	WeatherController.spawn_rotting_grass(60, -0.25, weather_node)
	await send_enemy(snail, 3, 1, path3)
	await send_enemy(armor_mushroom, 8, 1, path2)
	await send_enemy(squirrel, 50, 0.2)
	await delay(15)
	await send_enemy(tree_cutter, 4, 3, path4)

	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 2
	start_wave_timer(75)
	await send_enemy(mushroom, 50, 0.25, path2)
	#await delay(6)
	send_enemy(cow, 5, 2, path3)
	await delay(8)
	await send_enemy(excavator, 1, 3, path4)

	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 3
	start_wave_timer(75)
	WeatherController.spawn_harsh_sun(90, -0.25, weather_node)
	WeatherController.spawn_trash_wind(90, 20, -1, Vector2(-320, -280), Vector2(420, 180), weather_node)
	send_enemy(spore_crab, 4, 4, path2)
	await delay(0.5)
	await send_enemy(spore_crab, 4, 4, path2)
	await send_enemy(beetle, 10, 0.75, path3)
	await delay(3)
	await send_enemy(tree_cutter, 10, 1, path4)

	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()

	# wave 4
	start_wave_timer(75)
	WeatherController.spawn_acid_rain(60, -1, weather_node, 1.75)
	send_enemy(spore, 15, 2, path2)
	send_enemy(excavator, 5, 3, path4)
	await delay(5)
	await send_enemy(tree_cutter, 15, 1, path3)

	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 5
	start_wave_timer(3600)
	send_enemy(spore_crab, 8, 2, path2)
	send_enemy(mushroom, 30, 0.5, path2)
	await delay(6)
	await send_enemy(armor_mushroom, 30, 0.5, path2)
	await delay(5)
	await send_enemy(beetle, 5, 1, path3)
	await send_enemy(tree_cutter, 5, 1, path4)
	await send_enemy(atlas, 1, 2, path4)
	await delay(5)
	await send_enemy(atlas2, 1, 1, path3)
	await delay(10)
	send_enemy(excavator, 5, 1, path4)
	send_enemy(beetle, 20, 1, path3)


	
	currently_sending = false
	await wave_timer.timeout
