extends WaveSpawner

@onready var lvl7_dialogue: DialogueBox = $"../DialogueUI/DialogueBox"
@onready var manual_wave_button: Button = $"../Start Button/MarginContainer/VBoxContainer/HBoxContainer/StartWave"
@onready var path2: Path2D = $"../EnemyPath2"
@onready var path3: Path2D = $"../EnemyPath3"
@onready var path4: Path2D = $"../EnemyPath4"

func _ready() -> void:
	super._ready()
	wave_bonus_money = [0, 75, 100, 125, 175]
	lvl7_dialogue.start_wave.connect(_on_start_lvl7)
	manual_wave_button.button_down.connect(_on_start_lvl7)
	Tower.update_min_max_pos(Vector2(-320, -280), Vector2(420, 180))

func _on_start_lvl7() -> void:
	# test wave
	start_wave_timer(3000)
	await send_enemy(atlas, 1, 1, path4)
	await send_enemy(atlas2, 1, 1, path3)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 1
	start_wave_timer(67)
	await delay(3)
	await send_enemy(bush, 20, 0.5)
	await send_enemy(squirrel, 20, 1, path3)
	await send_enemy(cow, 1, 1, path3)
	
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()

	# wave 2
	start_wave_timer(60)
	WeatherController.spawn_wind(45, 0.35, -0.35, 1, weather_node, true, Vector2(420, 180), Vector2(-320, -280))
	WeatherController.spawn_trash_wind(45, 20, 1, Vector2(-320, -280), Vector2(420, 180), weather_node)
	send_enemy(armor_mushroom, 10, 1)
	await send_enemy(hornet, 20, 1, path3, -0.5)
	
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()

	# wave 3
	start_wave_timer(60)
	WeatherController.spawn_acid_rain(100, -1, weather_node, 1.75)
	await send_enemy(bush, 10, 1, path3)
	await send_enemy(mushroom, 20, 0.5, path_2d, -0.5)
	await send_enemy(beetle, 1, 2)
	await send_enemy(beetle, 1, 2, path3)
	
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()

	# wave 4
	start_wave_timer(85)
	#WeatherController.spawn_rotting_grass(60, -0.25, weather_node)
	send_enemy(snail, 5, 5, path3)
	await delay(5)
	send_enemy(spore_crab, 5, 2, path2)
	await delay(3)
	await send_enemy(armor_mushroom, 20, 1, path2)
	await send_enemy(squirrel, 10, 0.25, path3)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()

	# wave 5
	start_wave_timer(3600)
	WeatherController.spawn_rotting_grass(90, -0.5, weather_node)
	WeatherController.spawn_wind(45, 0.25, -0.35, -1, weather_node, true, Vector2(420, 180), Vector2(-320, -280))
	send_enemy(snail, 5, 3)
	await delay(15)
	send_enemy(hornet, 10, 2)
	await delay(0.5)
	send_enemy(hornet, 10, 2, path3)
	send_enemy(spore, 20, 1.5, path2)
	await send_enemy(queen_hornet, 1, 1)
	await delay(15)
	send_enemy(squirrel, 40, 0.25, path3)
	await send_enemy(hornet, 15, 0.5, path3)
	await send_enemy(hornet, 15, 0.5, path_2d)
	
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
