extends CanvasLayer
class_name UserInterface

@export var tint_during_pause : bool = false
@export var hide_during_pause : bool = false

func _ready() -> void:
	if tint_during_pause:
		PauseUi.pause_activated.connect(tint_ui)
	if hide_during_pause:
		PauseUi.pause_activated.connect(hide_ui)


func tint_ui(paused) -> void:
	for i in range(get_child_count()):
		var scene = self.get_child(i)
		if paused:
			scene.modulate = Color(0.5, 0.5, 0.5)
		elif !paused:
			scene.modulate = Color(1, 1, 1)

func hide_ui(paused) -> void:
	for i in range(get_child_count()):
		var scene = self.get_child(i)
		if paused:
			scene.visible = false
		elif !paused:
			scene.visible = true
