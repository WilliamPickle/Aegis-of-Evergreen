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
	start_wave_timer(35)
	await send_enemy(bush, 10, 0.5)
	await delay(5)
	await send_enemy(mushroom, 3, 0.5, path2)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
