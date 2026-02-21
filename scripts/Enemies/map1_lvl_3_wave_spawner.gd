extends WaveSpawner

@onready var lvl3_dialogue: DialogueBox = $"../DialogueUI/DialogueBox"
@onready var manual_wave_button: Button = $"../Start Button/MarginContainer/VBoxContainer/HBoxContainer/StartWave"

func _ready() -> void:
	super._ready()
	wave_bonus_money = [0, 55, 100, 150, 175]
	lvl3_dialogue.start_wave.connect(_on_start_lvl3)
	manual_wave_button.button_down.connect(_on_start_lvl3)

func _on_start_lvl3() -> void:
	# test wave
	#start_wave_timer(90)
	#await send_enemy(bush, 1, 0.2)
	#await send_enemy(squirrel, 1, 0.2)
	#await send_enemy(cow, 1, 0.2)
	#await send_enemy(snail, 1, 0.2)
	#await send_enemy(beetle, 1, 0.2)
	#await send_enemy(hornet, 1, 0.2)
	#await send_enemy(queen_hornet, 1, 0.2)
	#
	#
	#currently_sending = false
	#await wave_timer.timeout
	
	# wave 1
	start_wave_timer(65)
	await send_enemy(snail, 1, 0.5)
	await delay(5)
	await send_enemy(bush, 16, 0.5)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 2
	start_wave_timer(45)
	await send_enemy(bush, 20, 0.25)
	await delay(2)
	await send_enemy(hornet, 4, 0.5)
	#await delay(10)
	#await send_enemy(squirrel, 10, 0.5)

	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()

	# wave 3
	start_wave_timer(45)
	await send_enemy(hornet, 12, 0.2)
	await delay(4)
	await send_enemy(squirrel, 16, 0.15)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
	# wave 4
	start_wave_timer(60)
	await send_enemy(snail, 3, 4)
	await delay(3)
	await send_enemy(beetle, 3, 1)
	await delay(5)
	await send_enemy(hornet, 12, 0.2)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()

	# wave 5
	start_wave_timer(3600)
	await send_enemy(cow, 3, 1)
	await delay(3)
	await send_enemy(queen_hornet, 1, 1)
	await delay(5)
	await send_enemy(hornet, 5, 0.2)
	await delay(5)
	await send_enemy(hornet, 5, 0.2)
	await delay(5)
	await send_enemy(hornet, 5, 0.2)
	await delay(5)
	await send_enemy(squirrel, 10, 0.2)
	
	currently_sending = false
	await wave_timer.timeout
