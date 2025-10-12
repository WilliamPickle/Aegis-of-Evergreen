extends PathFollow2D

@export_range(0, 1, 0.05) var speed = 0.10

func _process(delta: float) -> void:
	progress_ratio += delta * speed
