extends Node2D
class_name Cutscene

@export var wait_time : float
@export var max_slides : int
@export var camera : Camera2D
@export var next_button : TextureButton
@export var skip_button : Icon

var default_color := Color(1,1,1)
var current_slide : int = 1

# Settings on the tween
# Basically how the button is gonna
# look when cutscene is "playing"
@onready var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)


func _ready() -> void:
	tween.tween_property(next_button, "modulate", default_color, wait_time)
	tween.tween_property(skip_button, "modulate", default_color, wait_time)
	tween.finished.connect(disable_buttons.bind(false))
	next_button.pressed.connect(next_scene)

# Makes it so the button is clickable or not
func disable_buttons(disabled : bool = true):
	tween.stop()
	next_button.disabled = disabled
	skip_button.disabled = disabled
	

# When the next scene button is clicked this
# Moves the camera to the next "scene" (cutscene)
func next_scene() -> void:
	# If player has reached the last scene
	# Load the corresponding level
	if current_slide == max_slides:
		var file_path : String = skip_button.file_path
		SceneLoader.quick_add_scene(file_path,"level_1",SceneLoader.current_main_scene)
		SceneLoader.current_main_scene = file_path.get_file().get_basename()
		return
	disable_buttons()
	next_button.modulate = Color(0,0,0)
	skip_button.modulate = Color(0,0,0)
	camera.global_position += Vector2(320, 0)
	current_slide += 1
	tween.play()
