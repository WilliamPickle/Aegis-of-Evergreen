extends Icon
@onready var wave_spawner: WaveSpawner = $"../../WaveSpawner"
@onready var tree = get_tree()

func _ready() -> void:
	super._ready()
	button_up.disconnect(load_icon_scene)
	button_down.connect(clear_tutorial)
	
# this is to mimic as if you'd just completed the tutorial
# so the rest of the game updates accordingly
func clear_tutorial() -> void:
	#$"../ClickMask".visible = true
	$"../../Dialogue".visible = false
	$"../../ClickMasks".visible = false
	$"../../ClickMasksNotUI".visible = false
	# mimic as if last wave was just beaten
	wave_spawner.final_wave_started = true
	wave_spawner.enemy_count = -1000
	PlayerStats.cur_money = 0
	wave_spawner.update_wave()
	# this is how much xp you would have gotten from the tutorial
	PlayerStats.PlayerXp = 1120
	PlayerStats.emit_signal("xp_changed")
	#undisable pause menu and other future disabled things like selling
	if tree.has_group("ui_buttons"):
		for button in tree.get_nodes_in_group("ui_buttons"):
			if button is Button:
				button.disabled = false
			button.remove_from_group("ui_buttons")
