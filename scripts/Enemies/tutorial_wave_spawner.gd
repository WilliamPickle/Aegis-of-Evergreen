extends WaveSpawner

@onready var wave1_dialogue: DialogueBox = $"../Dialogue/BeforeWave1"
@onready var wave2_dialogue: DialogueBox = $"../Dialogue/BeforeWave2"
@onready var wave3_dialogue: DialogueBox = $"../Dialogue/BeforeWave3"

func _ready() -> void:
	super._ready()
	max_waves = 3
	wave_bonus_money = [0, 50, 80]
	wave1_dialogue.start_wave.connect(_on_start_wave1)
	wave2_dialogue.start_wave.connect(_on_start_wave2)
	wave3_dialogue.start_wave.connect(_on_start_wave3)

# later on this function can be changed to only send out level 1.
# await makes it so you must wait for the previous enemies to send out first
# without await, functions run simulatenously. 
func _on_start_wave1() -> void:
	# wave 1 - 30 cash gain
	start_wave_timer(3600)
	await send_enemy(bush, 3, 6)
	
	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()


func _on_start_wave2() -> void:
	# wave 2
	start_wave_timer(3600)
	await send_enemy(bush, 2, 0.5)
	await delay(4)
	await send_enemy(bush, 2, 0.5)
	await delay(4)
	await send_enemy(bush, 2, 0.5)
	# should have 45 bucks after defeating bushes

	currently_sending = false
	await wave_timer.timeout
	signify_wave_end()
	
func _on_start_wave3() -> void:
	# wave 3
	start_wave_timer(3600)
	await send_enemy(bush, 20, 0.5)

	currently_sending = false
	await wave_timer.timeout
