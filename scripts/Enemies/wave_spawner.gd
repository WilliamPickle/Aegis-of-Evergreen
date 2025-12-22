extends Node2D

# variables for the actual wave spawning
@export var timer: Timer
@export var path_2d: Path2D
@export var path_spread: float
var bush := preload("res://scenes/Enemies/blackberry_bush.tscn")

# variables to initialize waves after dialogue
@onready var lvl1_dialogue: DialogueBox = $"../DialogueUI/DialogueBox"


func _ready() -> void:
	lvl1_dialogue.start_wave.connect(_on_start_wave)
	
# later on this function can be changed to only send out level 1.
# await makes it so you must wait for the previous enemies to send out first
# without await, functions run simulatenously. 
func _on_start_wave() -> void:
	await send_enemy(bush, 3, 1)
	await delay(1)
	await send_enemy(bush, 150, 0.2)

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
