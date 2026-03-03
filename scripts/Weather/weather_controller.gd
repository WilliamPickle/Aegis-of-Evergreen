extends Node

const WEATHERS = {
	"rain" : preload("res://scenes/Weather/rain.tscn")
}
# duration, which can be modular (towers placed in map and base hp %)
const STAT_TYPES = StatChanger.Type

func spawn_rain(duration : float, buff_percent: float, weather_placement : Node2D):
	var rain = WEATHERS["rain"].instantiate()
	rain.init(duration, buff_percent)
	weather_placement.add_child(rain)
