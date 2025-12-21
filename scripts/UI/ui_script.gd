extends CanvasLayer
class_name UserInterface

@export var pausable : bool = false

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	if pausable:
		PauseUi.pause_activated.connect(tint_ui)


func tint_ui(paused) -> void:
	var scene = self.get_child(0)
	if paused:
		scene.modulate = Color(0.5, 0.5, 0.5)
	elif !paused:
		scene.modulate = Color(1, 1, 1)
