extends Node2D

func _ready() -> void:
	SceneLoader.root = self
	# Just a one off thing, _current_scenes wont ever be refrenced again.
	SceneLoader._current_scenes["main_menu"] = self.get_child(0)
