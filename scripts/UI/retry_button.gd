extends Icon
@onready var lose_ui: UserInterface = $"../../.."
const levels_list = [
	"res://scenes/level_1.tscn", 
	"res://scenes/level_2.tscn", 
	"res://scenes/level_3.tscn", 
	"res://scenes/map_2_level_1.tscn", 
	"res://scenes/map_2_level_2.tscn", 
	"res://scenes/map_2_level_3.tscn", 
	"res://scenes/map_3_level_1.tscn",
	"res://scenes/map_3_level_2.tscn",
	"res://scenes/map_3_level_3.tscn"
	]
const restart_pity_money: float = 25

func _ready() -> void:
	file_path = levels_list[PlayerStats.lvls_beaten]
	#print("current retry level: ", file_path)
	if has_text:
		mouse_entered.connect(enable_text)
		mouse_exited.connect(enable_text.bind(false))
	button_up.connect(func(): file_path = levels_list[PlayerStats.lvls_beaten])
	button_up.connect(load_icon_scene)
	button_up.connect(remove_lose_screen)
	
func remove_lose_screen():
	PauseUi.toggle_pause(lose_ui)
	Tower.current_tower = null
	ControlHandler.current_states.erase(ControlHandler.ControlState.VIEWING_TOWER)
	SceneLoader.change_scene_visibility("lose_ui", false)
	SceneLoader.tint_scene(SceneLoader.current_main_scene, false)
	PlayerStats.pity_money += restart_pity_money
	PlayerStats.cur_money = PlayerStats.DEFAULT_MONEY[floori(PlayerStats.lvls_beaten / 3)][PlayerStats.lvls_beaten % 3] + PlayerStats.pity_money
	Tower.reset_hero_data()
	PlayerStats.emit_signal("money_changed")
