extends Node2D

func _ready() -> void:
	SceneLoader.root = self
	# Just a one off thing, _current_scenes wont ever be refrenced again.
	# This script is basically just to grab the current scene right as the scene launches? 
	SceneLoader._current_scenes["start_menu"] = self.get_child(0)
