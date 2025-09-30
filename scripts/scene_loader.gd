extends Node2D

# List of all scenes under parent. 
# Important mostly for loading settings menu.
var root
var _current_scenes = {}

## Adds a scene given the file path and key for future refrence.
func load_scene(file_path : String, new_key : String) -> void:
	var new_scene = load(file_path).instantiate()
	root.add_child(new_scene)
	_current_scenes[new_key] = new_scene

## Deletes a specific scene given the key.
func delete_scene(key : String) -> void:
	_current_scenes[key].queue_free()
	_current_scenes.erase(key)

## Deletes the stated scene while also adding a stated scene.
## A combination of both delete_scene() and load_scene.
func quick_add_scene(file_path : String, new_key : String, old_scene_key : String) -> void:
	delete_scene(old_scene_key)
	load_scene(file_path,new_key)
	

## Change the visibily of a scene.
## Internally keeping the memory but removing the scene fucntionality.
## [codeblock] change_scene_visibility("settings",false) [/codeblock]
func change_scene_visibility(key : String, scene_visible : bool) -> void:
	if scene_visible:
		root.add_child(_current_scenes[key])
	else:
		root.remove_child(_current_scenes[key])
		
#tint the sprites in a scene
func tint_scene(key : String, r, g, b) -> void:
	_current_scenes[key].modulate = Color(r, g, b);
	
func disable_scene(key : String, disable) -> void:
	if disable:
		_current_scenes[key].process_mode = ProcessMode.PROCESS_MODE_DISABLED;
	if not disable:
		_current_scenes[key].process_mode = ProcessMode.PROCESS_MODE_ALWAYS;
