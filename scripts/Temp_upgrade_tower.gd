extends Button

func _ready() -> void:
	button_down.connect(func():
		if Tower.current_tower != null and Tower.current_tower.level < 2:
			Tower.current_tower.level += 1
		)
