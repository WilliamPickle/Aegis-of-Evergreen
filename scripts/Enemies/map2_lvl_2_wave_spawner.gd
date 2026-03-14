extends WaveSpawner

@onready var lvl5_dialogue: DialogueBox = $"../DialogueUI/DialogueBox"
@onready var manual_wave_button: Button = $"../Start Button/MarginContainer/VBoxContainer/HBoxContainer/StartWave"
@onready var path2: Path2D = $"../EnemyPath2"

func _ready() -> void:
	super._ready()
	wave_bonus_money = [0, 75, 100, 115, 130]
	lvl5_dialogue.start_wave.connect(_on_start_lvl5)
	manual_wave_button.button_down.connect(_on_start_lvl5)

func _on_start_lvl5() -> void:
	# wave 1
	start_wave_timer(60)
	await delay(3)
	await send_enemy(bush, 20, 0.5)
	await send_enemy(armor_mushroom, 3, 3, path2)
	WeatherController.spawn_wind(30, 0.25, -0.5, -1, weather_node)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
