extends UserInterface

@onready var tree = get_tree()
@onready var play_button: Icon = $"Play Button2"
@onready var skip_button: Button = $"Skip Button2"
@onready var dialogue: CanvasLayer = $"../Dialogue"

func _ready() -> void:
	dialogue.process_mode = PROCESS_MODE_PAUSABLE
	tree.paused = true
	play_button.button_down.connect(clear_prompt)
	skip_button.button_down.connect(clear_prompt)
	
func clear_prompt() -> void:
	visible = false
	tree.paused = false
	dialogue.process_mode = PROCESS_MODE_ALWAYS
