extends Node2D
var ran_dict : Dictionary[String, int] = {
	"Test" : 2,
}

@onready var timer = $Timer
func _ready() -> void:
	timer.start(5)
	await timer.timeout
	var test = load("res://scenes/Weather/harsh_sun_scene.tscn").instantiate()
	add_child(test)
