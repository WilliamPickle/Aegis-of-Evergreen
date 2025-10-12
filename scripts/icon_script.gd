extends Button
class_name Icon

static var ui_open := false
static var current_scene_key : String
@export var file_path : String
@export var has_text : bool
@export var new_scene : bool

func _ready() -> void:
	if has_text:
		mouse_entered.connect(enable_text)
		mouse_exited.connect(enable_text.bind(false))
	button_down.connect(load_icon_scene)
	
# enabled the text's visibility
func enable_text(enable : bool = true):
	get_child(0).visible = enable

# Loads the scene path given on the Icon button class
func load_icon_scene():
	## Temp if statement
	if file_path == "":
		print("Still waiting on a scene!!!!!")
		return
	if ui_open:
		return
	
	var new_key = file_path.get_file().get_basename()
	current_scene_key = new_key
	if new_scene:
		SceneLoader.quick_add_scene(file_path, new_key,SceneLoader.current_main_scene)
		SceneLoader.current_main_scene = new_key
	else:
		SceneLoader.tint_scene()
		SceneLoader.load_scene(file_path, new_key)
		ui_open = true
