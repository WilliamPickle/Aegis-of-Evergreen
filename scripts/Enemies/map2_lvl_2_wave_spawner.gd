extends WaveSpawner

@onready var lvl5_dialogue: DialogueBox = $"../DialogueUI/DialogueBox"
@onready var manual_wave_button: Button = $"../Start Button/MarginContainer/VBoxContainer/HBoxContainer/StartWave"
@onready var path2: Path2D = $"../EnemyPath2"

func _ready() -> void:
	super._ready()
	wave_bonus_money = [0, 75, 75, 100, 100]
	lvl5_dialogue.start_wave.connect(_on_start_lvl5)
	manual_wave_button.button_down.connect(_on_start_lvl5)

func _on_start_lvl5() -> void:
	## test wave
	#start_wave_timer(3000)
	#await send_enemy(spore_crab, 3, 3, path2)
	#
	#currently_sending = false
	#await wave_timer.timeout
	#signify_wave_end()
	
	
	# wave 1
	start_wave_timer(60)
	await delay(3)
	send_enemy(armor_mushroom, 3, 4, path2)
	await send_enemy(bush, 30, 0.5)
	WeatherController.spawn_wind(25, 0.25, -0.5, -1, weather_node)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 2
	start_wave_timer(45)
	WeatherController.spawn_trash_wind(45, 40, 1, Vector2(-320, -280), Vector2(320, 180), weather_node)
	WeatherController.spawn_wind(45, 0.25, -0.25, 1, weather_node)
	await send_enemy(cow, 1, 1)
	await delay(1)
	await send_enemy(squirrel, 30, 0.25)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()

	# wave 3
	start_wave_timer(45)
	WeatherController.spawn_rotting_grass(60, -0.25, weather_node)
	send_enemy(mushroom, 12, 1, path2)
	await delay(0.5)
	await send_enemy(armor_mushroom, 12, 1, path2)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()

	# wave 4
	start_wave_timer(60)
	send_enemy(snail, 5, 1)
	await send_enemy(spore_crab, 3, 3, path2)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 5
	start_wave_timer(3600)
	WeatherController.spawn_trash_wind(90, 40, -1, Vector2(-320, -280), Vector2(320, 180), weather_node)
	await send_enemy(spore_crab, 6, 2, path2)
	await delay(2)
	send_enemy(cow, 4, 2, path_2d, -0.25)
	await delay(0.5)
	await send_enemy(cow, 4, 2, path_2d, -0.25)
	
	currently_sending = false
	await wave_timer.timeout
