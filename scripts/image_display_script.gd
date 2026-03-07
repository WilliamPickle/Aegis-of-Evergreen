extends TextureButton

func _ready() -> void:
	mouse_entered.connect(func():
		print("Mouse is HERE!!")
	)
