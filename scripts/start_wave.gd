extends Button
signal start_wave

@onready var button: Button = $"."

func _ready() -> void:
	button.pressed.connect(_button_pressed)
		
func _button_pressed():
	emit_signal("start_wave")
