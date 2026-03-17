extends WaveSpawner

@onready var lvl1_dialogue: DialogueBox = $"../DialogueUI/DialogueBox"
@onready var manual_wave_button: Button = $"../Start Button/MarginContainer/VBoxContainer/HBoxContainer/StartWave"
static var music_started = false

func _ready() -> void:
	super._ready()
	if !music_started and is_instance_valid(SceneLoader.root):
		music_started = true
		SceneLoader.root.emit_signal("gameplay_started")
	lvl1_dialogue.start_wave.connect(_on_start_lvl1)
	manual_wave_button.button_down.connect(_on_start_lvl1)

# later on this function can be changed to only send out level 1.
# await makes it so you must wait for the previous enemies to send out first
# without await, functions run simulatenously. 
func _on_start_lvl1() -> void:
	# wave 1 - 30 cash gain
	start_wave_timer(45)
	# send_enemy(cow, 10, 5) # ONLY FOR TESTING
	await send_enemy(bush, 4, 3)
	#WeatherController.spawn_rain(20,-0.5, get_parent().get_node("WeatherPlacement"))
	#WeatherController.spawn_harsh_sun(30,50,weather_node)
	#WeatherController.spawn_acid_rain(30,-0.5,weather_node,1)
	#WeatherController.spawn_wind(30, 1, -0.5, 1, weather_node)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	#WeatherController.spawn_rotting_grass(30,-0.5, weather_node)
	#WeatherController.spawn_acid_rain(30, -1, weather_node, 1)
	
	# wave 2 - 80 cash gain
	start_wave_timer(45)
	WeatherController.spawn_rain(30, -0.25, weather_node)
	await send_enemy(bush, 5, 1)
	await delay(3)
	await send_enemy(bush, 5, 1)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 3 - 75 cash gain
	start_wave_timer(45)
	send_enemy(squirrel, 10, 0.2)
	await delay(3)
	await send_enemy(squirrel, 4, 1)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 4 - 210 cash gain
	start_wave_timer(60)
	await send_enemy(bush, 20, 0.5)
	await delay(6)
	await send_enemy(squirrel, 30, 0.4)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 5 - 300 cash gain
	start_wave_timer(3600)
	WeatherController.spawn_rain(60, -0.35, weather_node)
	await send_enemy(bush, 30, 0.2)
	await send_enemy(cow, 2, 0.5)
	await delay(1)
	await send_enemy(squirrel, 40, 0.75)
	
	currently_sending = false
	await wave_timer.timeout
