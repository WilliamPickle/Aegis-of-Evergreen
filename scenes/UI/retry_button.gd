extends Icon
@onready var lose_ui: UserInterface = $"../../.."

func _ready() -> void:
	if has_text:
		mouse_entered.connect(enable_text)
		mouse_exited.connect(enable_text.bind(false))
	button_up.connect(load_icon_scene)
	button_up.connect(remove_lose_screen)
	
func remove_lose_screen():
	PauseUi.toggle_pause(lose_ui)
	SceneLoader.change_scene_visibility("lose_ui", false)
	SceneLoader.tint_scene(SceneLoader.current_main_scene, false)
	PlayerStats.cur_money = PlayerStats.DEFAULT_MONEY[floori(PlayerStats.lvls_beaten / 3)][PlayerStats.lvls_beaten % 3]
