extends Node2D

func _ready() -> void:
	SceneLoader.root = self
	# Just a one off thing, _current_scenes wont ever be refrenced again.
	# Since the game starts off with start_menu already loaded we assign it.
	SceneLoader._current_scenes["start_menu"] = self.get_child(0)
	
	SceneLoader.current_main_scene = "start_menu"
