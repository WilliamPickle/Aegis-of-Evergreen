extends WaveSpawner

@onready var lvl4_dialogue: DialogueBox = $"../DialogueUI/DialogueBox"
@onready var manual_wave_button: Button = $"../Start Button/MarginContainer/VBoxContainer/HBoxContainer/StartWave"
@onready var path2: Path2D = $"../EnemyPath2"
@onready var temp_screen: UserInterface = $"../TempWinScreen"

func _ready() -> void:
	super._ready()
	wave_bonus_money = [0, 75, 100, 115, 130]
	lvl4_dialogue.start_wave.connect(_on_start_lvl4)
	manual_wave_button.button_down.connect(_on_start_lvl4)

func _on_start_lvl4() -> void:
	# test wave
	start_wave_timer(3000)
	await send_enemy(tanky_mushroom, 1, 2, path2)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 1
	start_wave_timer(35)
	await send_enemy(bush, 10, 0.5)
	await delay(5)
	await send_enemy(mushroom, 3, 0.5, path2)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 2
	start_wave_timer(35)
	send_enemy(mushroom, 10, 0.5, path2)
	await delay(8)
	await send_enemy(squirrel, 20, 0.5)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 3
	start_wave_timer(45)
	await send_enemy(bush, 15, 0.5)
	await delay(5)
	send_enemy(cow, 3, 0.5)
	await delay(10)
	await send_enemy(mushroom, 6, 0.5, path2)
	await send_enemy(hornet, 6, 0.5)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 4
	start_wave_timer(50)
	send_enemy(bush, 20, 0.5)
	await send_enemy(armor_mushroom, 10, 1, path2)
	await send_enemy(beetle, 2, 1)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 5
	start_wave_timer(3600)
	send_enemy(snail, 1, 0.1)
	await delay(10)
	send_enemy(mushroom, 10, 0.5, path2)
	await send_enemy(cow, 4, 0.5)
	send_enemy(armor_mushroom, 20, 0.5, path2)
	await delay(10)
	await send_enemy(snail, 1, 0.1)
	await send_enemy(beetle, 5, 1)
	
	currently_sending = false
	await wave_timer.timeout
	#temp_screen.visible = true
	
