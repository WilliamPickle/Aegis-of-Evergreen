extends Node2D

# needa turn off pause menu once you win so here's the variable
@export var pause_menu : UserInterface

# setup variables
@export var timer: Timer
@export var delay_timer: Timer
@export var wave_timer : Timer
@export var path_2d: Path2D
@export var path_spread: float
const bush := preload("res://scenes/Enemies/blackberry_bush.tscn")
const squirrel := preload("res://scenes/Enemies/squirrel.tscn")
const cow := preload("res://scenes/Enemies/cow.tscn")

# variables to initialize waves after dialogue
@onready var lvl1_dialogue: DialogueBox = $"../DialogueUI/DialogueBox"
@onready var manual_wave_button: Button = $"../Start Button/MarginContainer/VBoxContainer/HBoxContainer/StartWave"
@onready var wave_label: Label = $"Wave Text/WaveLabel"

# variables to track waves and send them
var enemy_count: int = 0
var currently_sending: bool = false
var final_wave_started: bool = false
var wave = 0
const max_waves = 5

func _ready() -> void:
	lvl1_dialogue.start_wave.connect(_on_start_lvl1)
	manual_wave_button.button_down.connect(_on_start_lvl1)
	
# later on this function can be changed to only send out level 1.
# await makes it so you must wait for the previous enemies to send out first
# without await, functions run simulatenously. 
func _on_start_lvl1() -> void:
	# wave 1 - 30 cash gain
	start_wave_timer(45)
	await send_enemy(bush, 6, 2)
	
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
	await send_enemy(squirrel, 10, 1)
	
	currently_sending = false
	await wave_timer.timeout
	
	# wave 4 - 210 cash gain
	start_wave_timer(45)
	send_enemy(bush, 30, 0.5)
	await delay(10)
	await send_enemy(squirrel, 20, 0.5)
	
	currently_sending = false
	await wave_timer.timeout
	
	# wave 5 - 300 cash gain
	start_wave_timer(45)
	send_enemy(cow, 3, 5)
	await delay(12)
	send_enemy(bush, 30, 0.2)
	await delay(12)
	await send_enemy(squirrel, 30, 0.2)
	
	currently_sending = false
	await wave_timer.timeout
	
	#
	




# sends an enemy a specified amount of times. 
func send_enemy(enemy, quantity: int, delay_time: float) -> void:
	var new_timer = Timer.new()
	self.add_child(new_timer)
	new_timer.wait_time = delay_time
	for i in range(quantity):
		new_timer.start()
		await new_timer.timeout
		
		var new_path := PathFollow2D.new()
		path_2d.add_child(new_path)
		new_path.rotates = false
		new_path.rotation = 0
		new_path.loop = false
		new_path.position.x = -270
		new_path.position.y = -100
		
		var new_enemy = enemy.instantiate()
		enemy_count += 1
		new_enemy.position.y += randi_range(-path_spread, path_spread)
		new_enemy.removed.connect(update_total_enemies.bind(new_enemy))
		new_path.add_child(new_enemy)
	new_timer.queue_free()
		
func update_total_enemies(enemy):
	enemy_count -= 1
	#print("current enemy count: ", enemy_count)
	if enemy_count <= 0 and !currently_sending:
		# logic to stop a wave
		wave_timer.stop()
		wave_timer.emit_signal("timeout")
		
		# win logic
		if final_wave_started:
			Engine.time_scale = 1
			pause_menu.visible = false
			wave_timer.wait_time = 3
			wave_timer.start()
			await wave_timer.timeout
			print("About to load win screen")
			print("Enemies left: ", enemy_count)
			SceneLoader.load_scene("res://scenes/UI/win_ui.tscn", "win_ui")
			PauseUi.toggle_pause(SceneLoader._current_scenes["win_ui"])
			print("Level 1 complete")
			
		if wave == max_waves:
			final_wave_started = true
			
		if is_instance_valid(enemy):
			enemy.disconnect("removed", update_total_enemies)
		
# stops the given function for a certain amount of time
func delay(delay_time) -> void:
	delay_timer.wait_time = delay_time
	delay_timer.start()
	await delay_timer.timeout
	
func start_wave_timer(time):
	wave += 1
	wave_label.text = "Wave " + str(wave) + "/5"
	wave_timer.wait_time = time
	wave_timer.start()
	currently_sending = true
