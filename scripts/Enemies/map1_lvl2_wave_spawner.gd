extends WaveSpawner

@onready var lvl2_dialogue: DialogueBox = $"../DialogueUI/DialogueBox"
@onready var manual_wave_button: Button = $"../Start Button/MarginContainer/VBoxContainer/HBoxContainer/StartWave"

func _ready() -> void:
	super._ready()
	wave_bonus_money = [0, 50, 75, 100, 80]
	lvl2_dialogue.start_wave.connect(_on_start_lvl2)
	manual_wave_button.button_down.connect(_on_start_lvl2)

func _on_start_lvl2() -> void:
	#start_wave_timer(300)
	#await send_enemy(beetle, 1, 1)
	#
	#currently_sending = false
	#await wave_timer.timeout
	# wave 1
	start_wave_timer(45)
	await send_enemy(bush, 6, 0.5)
	await send_enemy(squirrel, 3, 0.5)
	
	currently_sending = false
	await wave_timer.timeout
	
	# wave 2 - 80 cash gain
	start_wave_timer(60)
	await send_enemy(snail, 1, 1)
	await delay(6)
	await send_enemy(bush, 12, 0.7)
	
	currently_sending = false
	await wave_timer.timeout
	
	# wave 3 - 80 cash gain
	start_wave_timer(45)
	await send_enemy(snail, 2, 1)
	await delay(3)
	await send_enemy(bush, 10, 0.5)
	await send_enemy(squirrel, 4, 1)
	
	currently_sending = false
	await wave_timer.timeout
	
	# wave 4 - 80 cash gain
	start_wave_timer(45)
	send_enemy(snail, 3, 3)
	await delay(3)
	await send_enemy(cow, 2, 1)
	await delay(7)
	await send_enemy(squirrel, 10, 0.3)
	
	currently_sending = false
	await wave_timer.timeout
