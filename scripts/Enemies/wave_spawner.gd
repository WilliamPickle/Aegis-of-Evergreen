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
const hornet := preload("res://scenes/Enemies/hornet.tscn")
const queen_hornet := preload("res://scenes/Enemies/queen_hornet.tscn")
const mushroom := preload("res://scenes/Enemies/mushroom.tscn")
const armor_mushroom := preload("res://scenes/Enemies/armor_mushroom.tscn")
const spore_crab := preload("res://scenes/Enemies/spore_crab.tscn")
const spore := preload("res://scenes/Enemies/spore.tscn")
const tanky_mushroom := preload("res://scenes/Enemies/tanky_mushroom.tscn")
const amalgamushroom := preload("res://scenes/Enemies/amalgamushroom.tscn")
const tree_cutter := preload("res://scenes/Enemies/tree_cutter.tscn")
const excavator := preload("res://scenes/Enemies/excavator.tscn")
const atlas := preload("res://scenes/Enemies/atlas.tscn")
const atlas2 := preload("res://scenes/Enemies/atlas_2.tscn")

# variables to initialize waves after dialogue
@export var wave_label: Label

# variable to utilize weather controller
@export var weather_node: Node2D

# variables to track waves and send them
var enemy_count: int = 0
var currently_sending: bool = false
var final_wave_started: bool = false
var max_waves = 5
var wave_bonus_money: Array[float] = [0, 30, 75, 75, 75]
var wave := 1

# to prevent win condition being called from multiple enemy deaths
var won_level: bool = false

func _ready() -> void:
	print(get_tree().get_nodes_in_group("wavespawner"))
	wave_timer.timeout.connect(update_wave)


# sends an enemy a specified amount of times. 
func send_enemy(enemy, quantity: int, delay_time: float, parent_path : Path2D = path_2d, money_drop_percent : float = 0):
	var new_timer = Timer.new()
	var new_enemy
	self.add_child(new_timer)
	new_timer.wait_time = delay_time
	for i in range(quantity):
		new_timer.start()
		await new_timer.timeout
		
		var new_path := PathFollow2D.new()
		parent_path.add_child(new_path)
		new_path.rotates = false
		new_path.rotation = 0
		new_path.loop = false
		#new_path.position.x = -270
		new_path.position.y = -100
		
		new_enemy = enemy.instantiate()
		new_enemy.visible = false
		enemy_count += 1
		new_enemy.wave_number = wave
		new_enemy.position.y += randi_range(-path_spread, path_spread)
		new_enemy.removed.connect(update_total_enemies.bind(new_enemy))
		new_enemy.money_drop_variance = money_drop_percent
		new_path.add_child(new_enemy)
		await get_tree().process_frame
		new_enemy.visible = true
		new_enemy.set_collision_layer_value(2, true)
		#print("enemy position: ", new_enemy.position)
	new_timer.queue_free()
	
	# right now, spore crab uses this logic
	# also, only returns last enemy sent
	return new_enemy
	#print(wave)
		
func update_total_enemies(enemy):
	enemy_count -= 1
	#print("enemy_count: ", enemy_count)
	#print("current enemy count: ", enemy_count)
	# for some reason in the if statement, i had this conditional:  and wave == enemy.wave_number
	# I don't know what bug it was trying to fix but i've removed it b/c it's causing another bug
	#print("enemy_count: ", enemy_count)
	if enemy_count <= 0 and !currently_sending:
		#print("wave ", wave, " meant to stop")
		# logic to stop a wave
		wave_timer.stop()
		wave_timer.emit_signal("timeout")
			
		if is_instance_valid(enemy):
			enemy.disconnect("removed", update_total_enemies)
			
func update_wave():
	#print("wave ", wave, " ended")
	#print("The finale has started: ", final_wave_started)
	# win logic
	if final_wave_started and enemy_count <= 0:
		if won_level:
			return
		#print("entered wave_spawner update thingy")
		print("Total Cash Accumulated: $", PlayerStats.total_money_gained)
		won_level = true
		Engine.time_scale = 1
		pause_menu.visible = false
		fast_forward_button.visible = false
		wave_timer.wait_time = 1
		wave_timer.start()
		await wave_timer.timeout
		Tower.reset_hero_data()
		#print("About to load win screen")
		#print("Enemies left: ", enemy_count)
		#print("prev levels won:", PlayerStats.lvls_beaten)
		PlayerStats.lvls_beaten += 1
		PlayerStats.pity_money = 0
		PlayerStats.cur_money = PlayerStats.DEFAULT_MONEY[floori(PlayerStats.lvls_beaten / 3)][PlayerStats.lvls_beaten % 3] + PlayerStats.pity_money
		#print("levels won:", PlayerStats.lvls_beaten)
		#print("wave variable: ", wave)
		SceneLoader.load_scene("res://scenes/UI/win_ui.tscn", "win_ui")
		PauseUi.toggle_pause(SceneLoader._current_scenes["win_ui"])
		wave_timer.disconnect("timeout", update_wave)
		print("Current XP: ", PlayerStats.PlayerXp)
	
	#print("Final wave? ", final_wave_started)
		
# stops the given function for a certain amount of time
func delay(delay_time) -> void:
	delay_timer.wait_time = delay_time
	delay_timer.start()
	await delay_timer.timeout
	
func start_wave_timer(time):
	#wave += 1
	#PlayerStats.cur_money += wave_bonus_money[wave - 1]
	#PlayerStats.emit_signal("money_changed")
	#
	#if wave == max_waves:
		#final_wave_started = true
#
	## I kinda did some goofy logic so it thinks wave 1 is 
	## the end of a wave
	#if wave > 1:
		#var notif := Error_Notification.new()
		#get_child(2).add_child(notif)
		#notif.send_notif(Vector2(540,335),"wave_cleared", 1, "wave_clear")
		#print(notif.global_position)
	#wave_label.text = "Wave " + str(wave) + "/5"
	wave_timer.wait_time = time
	wave_timer.start()
	currently_sending = true
	
func signify_wave_end():
	wave += 1
	PlayerStats.cur_money += wave_bonus_money[wave - 1]
	PlayerStats.total_money_gained += wave_bonus_money[wave - 1]
	PlayerStats.emit_signal("money_changed")
	print("Total Cash Accumulated: $", PlayerStats.total_money_gained)
	
	if wave == max_waves:
		final_wave_started = true

	if wave > 1:
		var notif := Error_Notification.new()
		get_child(2).add_child(notif)
		notif.send_notif(Vector2(540,335),"wave_cleared", 1, "wave_clear")
		#print(notif.global_position)
	wave_label.text = "Wave " + str(wave) + "/" + str(max_waves)
