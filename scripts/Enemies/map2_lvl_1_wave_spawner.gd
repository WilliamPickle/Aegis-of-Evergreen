extends WaveSpawner

@onready var lvl4_dialogue: DialogueBox = $"../DialogueUI/DialogueBox"
@onready var manual_wave_button: Button = $"../Start Button/MarginContainer/VBoxContainer/HBoxContainer/StartWave"
@onready var path2: Path2D = $"../EnemyPath2"

func _ready() -> void:
	super._ready()
	wave_bonus_money = [0, 75, 125, 150, 175]
	lvl4_dialogue.start_wave.connect(_on_start_lvl4)
	manual_wave_button.button_down.connect(_on_start_lvl4)

func _on_start_lvl4() -> void:
	# wave 1
	start_wave_timer(45)
	send_enemy(bush, 5, 0.5)
	await delay(5)
	await send_enemy(mushroom, 3, 0.5, path2)
	
	currently_sending = false
	await wave_timer.timeout
