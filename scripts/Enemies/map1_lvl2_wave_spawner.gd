extends WaveSpawner

@onready var lvl2_dialogue: DialogueBox = $"../DialogueUI/DialogueBox"
@onready var manual_wave_button: Button = $"../Start Button/MarginContainer/VBoxContainer/HBoxContainer/StartWave"

func _ready() -> void:
	super._ready()
	wave_bonus_money = [0, 75, 75, 100, 150]
	lvl2_dialogue.start_wave.connect(_on_start_lvl2)
	manual_wave_button.button_down.connect(_on_start_lvl2)

func _on_start_lvl2() -> void:
	# wave 1
	start_wave_timer(30)
	await send_enemy(bush, 6, 0.5)
	await delay(5)
	WeatherController.spawn_rain(15, -.25, weather_node)
	await send_enemy(squirrel, 4, 2)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 2 - 80 cash gain
	start_wave_timer(75)
	await send_enemy(snail, 2, 1)
	await delay(6)
	await send_enemy(bush, 10, 0.3)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 3 - 80 cash gain
	start_wave_timer(65)
	await send_enemy(snail, 4, 1)
	await delay(3)
	await send_enemy(bush, 10, 0.5)
	await delay(7)
	await send_enemy(squirrel, 10, 0.5)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 4 - 80 cash gain
	start_wave_timer(60)
	WeatherController.spawn_wind(45, 0.25, -0.5, 1, weather_node)
	send_enemy(cow, 3, 0.3)
	await delay(5)
	send_enemy(bush, 30, 0.5)
	await delay(7)
	await send_enemy(squirrel, 20, 0.2)
	#await send_enemy(snail, 2, 0.5)
	#await delay(3)
	#send_enemy(snail, 2, 0.5)
	#await delay(3)
	#send_enemy(cow, 2, 0.3)
	#await delay(9)
	#await send_enemy(squirrel, 20, 0.2)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 5 - 80 cash gain
	start_wave_timer(3600)
	WeatherController.spawn_rain(60, -0.35, weather_node)
	send_enemy(cow, 4, 3)
	await delay(3)
	await send_enemy(bush, 20, 0.5)
	await delay(7)
	await send_enemy(beetle, 1, 2)
	await send_enemy(squirrel, 10, 1)
	
	currently_sending = false
	await wave_timer.timeout
