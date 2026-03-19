extends Icon
# note: whilst pause menu is still opened, but noti pops up, 
# it's still clickable?

# variables for the popup icon itself
@onready var x_button: Button = $Button
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@export var timer: Timer
var wait_time: float = 10

# variables for the guidebook
var guidebook: UserInterface
var guidebook_script
var back_button: Button
var page_index: float = 1

func _ready() -> void:
	super._ready()
	button_up.connect(open_guidebook)
	x_button.button_up.connect(remove_popup)
	timer.timeout.connect(remove_popup)
	timer.wait_time = wait_time
	timer.one_shot = true
	timer.autostart = true
	timer.ignore_time_scale = true
	timer.start()
	audio.play()
	
func remove_popup():
	queue_free()

func open_guidebook():
	guidebook = SceneLoader._current_scenes["survival_guide_menu"]
	guidebook_script = guidebook.get_node(str(guidebook.get_path()) + "/ScreenContainer")
	back_button = guidebook_script.back_button
	back_button.button_up.connect(unpause_game)
	
	# open up to designated page
	guidebook_script._show_page(int(page_index - 1))
	back_button.offset_left = 1926
	back_button.offset_top = 830
	back_button.offset_right = 1956
	back_button.offset_bottom = 860
	
	# pause game
	guidebook.visible = false #b/c pauseui script sucks we need this first to utilize it
	PauseUi.toggle_pause(guidebook)
	
func unpause_game():
	PauseUi.toggle_pause(guidebook)
	guidebook.visible = true #this is to prevent weird bugs between sceneloader and pauseui
	back_button.button_up.disconnect(unpause_game)
	remove_popup()
