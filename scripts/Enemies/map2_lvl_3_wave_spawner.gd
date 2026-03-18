extends WaveSpawner

@onready var lvl6_dialogue: DialogueBox = $"../DialogueUI/DialogueBox"
@onready var manual_wave_button: Button = $"../Start Button/MarginContainer/VBoxContainer/HBoxContainer/StartWave"
@onready var path2: Path2D = $"../EnemyPath2"

func _ready() -> void:
	super._ready()
	wave_bonus_money = [0, 75, 100, 100, 100]
	lvl6_dialogue.start_wave.connect(_on_start_lvl6)
	manual_wave_button.button_down.connect(_on_start_lvl6)
	Tower.update_min_max_pos(Vector2(-320, -280), Vector2(320, 180))

func _on_start_lvl6() -> void:
	# wave 1
	start_wave_timer(60)
	await delay(3)
	send_enemy(tanky_mushroom, 1, 0.1, path2)
	await send_enemy(mushroom, 15, 1, path2)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 2
	start_wave_timer(45)
	WeatherController.spawn_rotting_grass(120, -0.25, weather_node)
	send_enemy(spore, 6, 1, path2)
	await send_enemy(squirrel, 18, 0.33)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 3
	start_wave_timer(45)
	send_enemy(spore_crab, 2, 2, path2)
	await delay(15)
	await send_enemy(hornet, 20, 0.6, path2)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 4
	start_wave_timer(60)
	WeatherController.spawn_trash_wind(60, 15, -1, Vector2(-320, -280), Vector2(320, 180), weather_node)
	WeatherController.spawn_wind(60, 0.25, -0.35, -1, weather_node, false, Vector2(320, 180), Vector2(-320, -280))
	await send_enemy(mushroom, 10, 0.5, path2)
	await send_enemy(tanky_mushroom, 3, 3, path2)
	await send_enemy(beetle, 3, 1)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 5
	start_wave_timer(3600)
	send_enemy(snail, 3, 5)
	send_enemy(squirrel, 33, 0.33)
	await delay(3)
	send_enemy(armor_mushroom, 20, 2, path2)
	await send_enemy(amalgamushroom, 1, 1, path2)
	send_enemy(spore_crab, 5, 4, path2)
	
	
	currently_sending = false
	await wave_timer.timeout
