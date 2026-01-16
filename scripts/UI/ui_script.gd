extends CanvasLayer
class_name UserInterface

@export var tint_during_pause : bool = false
@export var hide_during_pause : bool = false

func _ready() -> void:
	if tint_during_pause:
		PauseUi.pause_activated.connect(tint_ui)
	if hide_during_pause:
		PauseUi.pause_activated.connect(hide_ui)
	print("linked up to: ", self.name)


func tint_ui(paused) -> void:
	var scene = self.get_child(0)
	if paused:
		scene.modulate = Color(0.5, 0.5, 0.5)
	elif !paused:
		scene.modulate = Color(1, 1, 1)

func hide_ui(paused) -> void:
	var scene = self.get_child(0)
	print("from hide ui: ", scene)
	if paused:
		scene.visible = false
	elif !paused:
		scene.visible = true
