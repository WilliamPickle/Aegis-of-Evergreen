extends Control

func _ready() -> void:
	for button : Button in $Background/Stats/BoxContainer.get_children():
		button.mouse_entered.connect(_enter_focus)
		button.mouse_exited.connect(_exit_focus)
		

func _enter_focus():
	print("Focused!!!!")
	
func _exit_focus():
	print("Exit Focus!!!!")
