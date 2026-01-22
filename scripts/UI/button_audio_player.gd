extends AudioStreamPlayer
@export_enum("confirm", "cancel") var sound = "confirm"
const confirm_sound := preload("res://assets/music/Confirm.mp3")
const cancel_sound := preload("res://assets/music/Cancel.mp3")

func _ready() -> void:
	if sound == "confirm":
		stream = confirm_sound
	elif sound == "cancel":
		stream = cancel_sound
	get_parent().button_up.connect(play_sound)
	
func play_sound():
	play()
