extends WaveSpawner

@onready var lvl1_dialogue: DialogueBox = $"../DialogueUI/DialogueBox"
@onready var manual_wave_button: Button = $"../Start Button/MarginContainer/VBoxContainer/HBoxContainer/StartWave"

func _ready() -> void:
	super._ready()
	lvl1_dialogue.start_wave.connect(_on_start_lvl1)
	manual_wave_button.button_down.connect(_on_start_lvl1)

# later on this function can be changed to only send out level 1.
# await makes it so you must wait for the previous enemies to send out first
# without await, functions run simulatenously. 
func _on_start_lvl1() -> void:
	# wave 1 - 30 cash gain
	start_wave_timer(45)
	await send_enemy(bush, 2, 0.5)
	await delay(2)
	await send_enemy(bush, 2, 0.5)
	await delay(2)
	await send_enemy(bush, 2, 0.5)
	
	currently_sending = false
	await wave_timer.timeout
	
	# wave 2 - 80 cash gain
	start_wave_timer(45)
	await send_enemy(bush, 8, 1)
	await delay(3)
	await send_enemy(bush, 8, 1)
	
	currently_sending = false
	await wave_timer.timeout
	
	# wave 3 - 75 cash gain
	start_wave_timer(45)
	send_enemy(squirrel, 15, 0.2)
	await delay(3)
	await send_enemy(squirrel, 5, 1)
	
	currently_sending = false
	await wave_timer.timeout
	
	# wave 4 - 210 cash gain
	start_wave_timer(60)
	send_enemy(bush, 30, 0.5)
	await delay(10)
	await send_enemy(squirrel, 20, 0.5)
	
	currently_sending = false
	await wave_timer.timeout
	
	# wave 5 - 300 cash gain
	start_wave_timer(3600)
	send_enemy(cow, 3, 5)
	await delay(12)
	send_enemy(bush, 30, 0.2)
	await delay(1)
	await send_enemy(squirrel, 28, 1)
	
	currently_sending = false
	await wave_timer.timeout
