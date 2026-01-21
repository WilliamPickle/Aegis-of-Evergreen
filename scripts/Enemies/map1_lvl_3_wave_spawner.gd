extends WaveSpawner

@onready var lvl3_dialogue: DialogueBox = $"../DialogueUI/DialogueBox"
@onready var manual_wave_button: Button = $"../Start Button/MarginContainer/VBoxContainer/HBoxContainer/StartWave"

func _ready() -> void:
	super._ready()
	wave_bonus_money = [0, 50, 75, 100, 125]
	lvl3_dialogue.start_wave.connect(_on_start_lvl3)
	manual_wave_button.button_down.connect(_on_start_lvl3)

func _on_start_lvl3() -> void:
	# wave 1
	start_wave_timer(45)
	await send_enemy(bush, 15, 1)
	await send_enemy(cow, 1, 1)
	
	currently_sending = false
	await wave_timer.timeout
