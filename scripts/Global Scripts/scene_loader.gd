extends Node2D

# List of all scenes under parent. 
# Important mostly for loading settings menu.
var root
var _current_scenes = {}

# Main scenes will only be main_menu, level_1, level_2, level_3.z
var current_main_scene

# For keeping track of whether or not tint_scene() is already in use by another scene
var layered_menu_exists = false

## Adds a scene given the file path and key for future refrence.
func load_scene(file_path : String, new_key : String) -> void:
	if _current_scenes.has(new_key):
		change_scene_visibility(new_key,true)
	else:
		var new_scene = load(file_path).instantiate()
		#print("root: ", root.name)
		#print("new_scene: ", new_scene)
		root.add_child(new_scene)
		_current_scenes[new_key] = new_scene

## Fully deletes a scene from game's memory.
## Use change_scene_visibility() for temporary scene deletion.
func delete_scene(key : String) -> void:
	_current_scenes[key].queue_free()
	_current_scenes.erase(key)

## Deletes the stated scene while also adding a stated scene.
## A combination of both delete_scene() and load_scene().
func quick_add_scene(file_path : String, new_key : String, old_scene_key : String) -> void:
	delete_scene(old_scene_key)
	load_scene(file_path,new_key)
	PlayerStats.display_map_collision()
	

## Change the visibily of a scene.
## Internally keeping the memory but removing the scene fucntionality.
## [codeblock] change_scene_visibility("settings_menu",false) [/codeblock]
func change_scene_visibility(key : String, scene_visible : bool) -> void:
	if scene_visible:
		root.add_child(_current_scenes[key])
	else:
		root.remove_child(_current_scenes[key])
		
## tint the sprites in a scene.
## by default it tints the main scene.
## layered_menu should be true if you're going to have another menu on that menu.
func tint_scene(key : String = current_main_scene, enable : bool = true, layered_menu : bool = false) -> void:
	# ex: pause menu should have layered_menu be true because it will have stuff like settings menu overlap. 
	# Without this, settings menu would undo the tinted background while pause menu is still up
	if layered_menu:
		layered_menu_exists = true
		
	if layered_menu_exists and layered_menu or !layered_menu_exists:
		if enable:
			_current_scenes[key].modulate = Color(0.5, 0.5, 0.5)
		else:
			_current_scenes[key].modulate = Color(1, 1, 1)
			layered_menu_exists = false


## Makes given scene stop functioning while keeping it visible.
func disable_scene(key : String, disable : bool) -> void:
	if disable:
		_current_scenes[key].process_mode = ProcessMode.PROCESS_MODE_DISABLED;
	if not disable:
		_current_scenes[key].process_mode = ProcessMode.PROCESS_MODE_ALWAYS;
