extends CanvasLayer
@onready var wave_spawner: WaveSpawner = $"../WaveSpawner"
@onready var tree = get_tree()
@onready var ui_buttons = tree.get_nodes_in_group("ui_buttons")
var dialogue_index : int = 0

# vars for specific moments in the tutorial
var pause_button : Button

func _ready() -> void:
	for i in range(get_child_count()):
		get_child(i).start_wave.connect(continue_dialogue)
		
func continue_dialogue():
	dialogue_index += 1
	# hardcoding certain interactions
	# After [node] dialogue runs, await signal 
	# and the next node immediately call display_dialogue()
	
	# After Placing dialogue
	if dialogue_index == 2:
		await PlayerStats.money_changed
	# After BeforeWave1 dialogue
	elif dialogue_index == 3:
		await wave_spawner.wave_timer.timeout
		$"Waves and Enemies/DialogueLabels/Label4".visibility_changed.connect(func():
			for button in tree.get_nodes_in_group("ui_buttons"):
				if button.name == "PauseButton":
					pause_button = button
					button.disabled = false
			)
	# After Waves and Enemies dialogue
	elif dialogue_index == 4:
		$"../ClickMasks/PauseButtonSpotlight".visible = true
		await PauseUi.pause_activated
		pause_button.disabled = true
		$"../ClickMasks/PauseButtonSpotlight".visible = false
		$Menus/DialogueLabels/Label2.visibility_changed.connect(func():
			for button in tree.get_nodes_in_group("ui_buttons"):
				if button is Button:
					button.disabled = false
				button.remove_from_group("ui_buttons")
			)
	# After Menu dialogue
	elif dialogue_index == 5:
		await PauseUi.pause_activated
	# After BeforeWave2 dialogue
	elif dialogue_index == 6:
		await wave_spawner.wave_timer.timeout
		PlayerStats.PlayerXp = 1000
		PlayerStats.emit_signal("xp_changed")
		
	# After Lvl Up and Heroes
	elif dialogue_index == 8:
		$"../ClickMasks/Ranger".visible = true
		await ControlHandler.card_clicked_on
		$"../ClickMasks/Ranger".visible = false
		# at this step player can technically cancel placement and 
		# place chipmunk instead but oh well
		await PlayerStats.money_changed
	# After Upgrade Menus
	elif dialogue_index == 9:
		var twr_highlight: Control  = $"../ClickMasksNotUI/TowerHighlight"
		var temp_twr_list := []
		for node in $"../PlacementCollisions".get_children():
			if node is Tower:
				temp_twr_list.append(node)
		if len(temp_twr_list) > 0:
			# All of this code was to determine the shadow position if it was UI
			#twr_highlight.global_position = Vector2(640, 360) + (temp_twr_list[randi_range(0, len(temp_twr_list) - 1)].global_position * 2)
			#twr_highlight.visible = true
			#print("tower pos: ", temp_twr_list[randi_range(0, len(temp_twr_list) - 1)].global_position)
			#print("position: ", twr_highlight.position)
			#print("global position: ", twr_highlight.global_position)
			twr_highlight.global_position = temp_twr_list[randi_range(0, len(temp_twr_list) - 1)].global_position
			twr_highlight.visible = true
			
		# note this signal doesn't trigger if a menu is already open
		# and you upon the menu for a dif tower
		await ControlHandler.tower_clicked_on
		twr_highlight.visible = false
		PlayerStats.cur_money += 125
		PlayerStats.emit_signal("money_changed")
	# After BeforeWave2 dialogue
	#elif dialogue_index == 10:

	
	
	if dialogue_index < get_child_count():
		get_child(dialogue_index - 1).visible = false
		get_child(dialogue_index).visible = true
		get_child(dialogue_index).display_dialogue()
