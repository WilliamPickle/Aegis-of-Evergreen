extends Node2D

# variables for the actual wave spawning
@export var timer: Timer
@export var wave_timer : Timer
@export var path_2d: Path2D
@export var path_spread: float
const bush := preload("res://scenes/Enemies/blackberry_bush.tscn")
const squirrel := preload("res://scenes/Enemies/squirrel.tscn")
const cow := preload("res://scenes/Enemies/cow.tscn")

# variables to initialize waves after dialogue
@onready var lvl1_dialogue: DialogueBox = $"../DialogueUI/DialogueBox"
@onready var manual_wave_button: Button = $"../Start Button/MarginContainer/VBoxContainer/HBoxContainer/StartWave"


func _ready() -> void:
	lvl1_dialogue.start_wave.connect(_on_start_lvl1)
	manual_wave_button.button_down.connect(_on_start_lvl1)
	
# later on this function can be changed to only send out level 1.
# await makes it so you must wait for the previous enemies to send out first
# without await, functions run simulatenously. 
func _on_start_lvl1() -> void:
	# wave 1
	wave_timer.wait_time = 10
	wave_timer.start()
	await send_enemy(cow, 10, 0.2)
	await delay(1)
	await send_enemy(bush, 10, 0.2)
	
	await wave_timer.timeout
	# wave 2
	print("wave 2 started")
	await send_enemy(cow, 3, 1)
	await delay(1)
	await send_enemy(squirrel, 60, 0.1)




# sends an enemy a specified amount of times. 
func send_enemy(enemy, quantity: int, delay_time: float) -> void:
	timer.wait_time = delay_time
	for i in range(quantity):
		timer.start()
		await timer.timeout
		
		var new_path := PathFollow2D.new()
		path_2d.add_child(new_path)
		new_path.rotates = false
		new_path.rotation = 0
		new_path.loop = false
		new_path.position.x = -270
		new_path.position.y = -100
		
		var new_enemy = enemy.instantiate()
		new_enemy.position.y += randi_range(-path_spread, path_spread)
		new_path.add_child(new_enemy)

# stops the given function for a certain amount of time
func delay(delay_time) -> void:
	timer.wait_time = delay_time
	timer.start()
	await timer.timeout
