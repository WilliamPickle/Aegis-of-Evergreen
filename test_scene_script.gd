extends Node2D
var ran_dict : Dictionary[String, int] = {
	"Test" : 2,
}

@onready var timer = $Timer
func _ready() -> void:
	timer.start(5)
	await timer.timeout
	WeatherController.spawn_harsh_sun(30,-0.5, $WeatherPlacement)
