extends Button
class_name Icon

static var ui_open := false
static var current_scene_key : String
var icon_scene
@export var file_path : String
@export var has_text : bool
@export var new_scene : bool
@export var scene_scale : float = 1
@export var hide_pause_menu : bool = false

func _ready() -> void:
	if has_text:
		mouse_entered.connect(enable_text)
		mouse_exited.connect(enable_text.bind(false))
	button_up.connect(load_icon_scene)
	
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
		
	if SceneLoader._current_scenes[new_key].get_class() == "CanvasLayer":
		icon_scene = SceneLoader._current_scenes[new_key].get_child(0)
		icon_scene.pivot_offset = Vector2(icon_scene.size / 2)
		icon_scene.scale = Vector2(scene_scale, scene_scale)
	
	if hide_pause_menu:
		print("load icon scene ran")
		PauseUi.emit_signal("secondary_ui_open", true)
