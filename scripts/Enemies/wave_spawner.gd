extends Node2D
class_name WaveSpawner
## Class to create waves of enemies. 
## For each level, extend the script and hardcore the waves

# needa turn off these menus once you win so here's the variable
@export var pause_menu : UserInterface
@export var fast_forward_button : UserInterface

# setup variables
@export var delay_timer: Timer
@export var wave_timer : Timer
@export var path_2d: Path2D
@export var path_spread: float = 2.0
const bush := preload("res://scenes/Enemies/blackberry_bush.tscn")
const squirrel := preload("res://scenes/Enemies/squirrel.tscn")
const cow := preload("res://scenes/Enemies/cow.tscn")
const snail := preload("res://scenes/Enemies/snail.tscn")
const beetle := preload("res://scenes/Enemies/beetle.tscn")

# variables to initialize waves after dialogue
@export var wave_label: Label

# variables to track waves and send them
var enemy_count: int = 0
var currently_sending: bool = false
var final_wave_started: bool = false
var wave_bonus_money: Array[float] = [0, 50, 60, 60, 70]
var wave := 0
const max_waves = 5

func _ready() -> void:
	wave_timer.timeout.connect(update_wave)


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
		new_enemy.wave_number = wave
		new_enemy.position.y += randi_range(-path_spread, path_spread)
		new_enemy.removed.connect(update_total_enemies.bind(new_enemy))
		new_path.add_child(new_enemy)
	new_timer.queue_free()
	print(wave)
		
func update_total_enemies(enemy):
	enemy_count -= 1
	#print("current enemy count: ", enemy_count)
	# for some reason in the if statement, i had this conditional:  and wave == enemy.wave_number
	# I don't know what bug it was trying to fix but i've removed it b/c it's causing another bug
	if enemy_count <= 0 and !currently_sending:
		print("wave ", wave, " meant to stop")
		# logic to stop a wave
		wave_timer.stop()
		wave_timer.emit_signal("timeout")
			
		if is_instance_valid(enemy):
			enemy.disconnect("removed", update_total_enemies)
			
func update_wave():
	print("wave ", wave, " ended")
	print("The finale has started: ", final_wave_started)
	# win logic
	if final_wave_started:
		Engine.time_scale = 1
		pause_menu.visible = false
		fast_forward_button.visible = false
		wave_timer.wait_time = 1
		wave_timer.start()
		await wave_timer.timeout
		print("About to load win screen")
		print("Enemies left: ", enemy_count)
		SceneLoader.load_scene("res://scenes/UI/win_ui.tscn", "win_ui")
		PauseUi.toggle_pause(SceneLoader._current_scenes["win_ui"])
		PlayerStats.lvls_beaten += 1
		PlayerStats.cur_money = PlayerStats.DEFAULT_MONEY[floori(PlayerStats.lvls_beaten / 3)][PlayerStats.lvls_beaten % 3]
	
	print("Final wave? ", final_wave_started)
		
# stops the given function for a certain amount of time
func delay(delay_time) -> void:
	delay_timer.wait_time = delay_time
	delay_timer.start()
	await delay_timer.timeout
	
func start_wave_timer(time):
	wave += 1
	if wave == max_waves:
		final_wave_started = true
	PlayerStats.cur_money += wave_bonus_money[wave - 1]
	PlayerStats.emit_signal("money_changed")
	wave_label.text = "Wave " + str(wave) + "/5"
	wave_timer.wait_time = time
	wave_timer.start()
	currently_sending = true
