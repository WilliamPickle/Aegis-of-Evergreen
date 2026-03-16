extends WaveSpawner

@onready var lvl7_dialogue: DialogueBox = $"../DialogueUI/DialogueBox"
@onready var manual_wave_button: Button = $"../Start Button/MarginContainer/VBoxContainer/HBoxContainer/StartWave"
@onready var path2: Path2D = $"../EnemyPath2"
@onready var path3: Path2D = $"../EnemyPath3"
@onready var path4: Path2D = $"../EnemyPath4"

func _ready() -> void:
	super._ready()
	wave_bonus_money = [0, 75, 100, 100, 100]
	lvl7_dialogue.start_wave.connect(_on_start_lvl7)
	manual_wave_button.button_down.connect(_on_start_lvl7)

func _on_start_lvl7() -> void:
	# wave 1
	start_wave_timer(60)
	send_enemy(tree_cutter, 5, 3, path4)
	await delay(1.5)
	send_enemy(excavator, 5, 3, path4)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
