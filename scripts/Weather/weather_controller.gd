extends Node

const WEATHERS = {
	"rain" : preload("res://scenes/Weather/rain_scene.tscn"),
	"wind" : preload("res://scenes/Weather/wind_scene.tscn")
}
# duration, which can be modular (towers placed in map and base hp %)
const STAT_TYPES = StatChanger.Type

func spawn_rain(duration : float, buff_percent: float, weather_placement : Node2D):
	var rain = WEATHERS["rain"].instantiate()
	rain.init(duration, buff_percent)
	#weather_placement.add_child(rain)
	weather_placement.call_deferred("add_child", rain)

func spawn_wind(duration : float, buff_percent : float, debuff_percent : float, direction : int, weather_placement : Node2D,):
	var wind = WEATHERS["wind"].instantiate()
	wind.init(duration, buff_percent, debuff_percent, direction)
	#map_area.call_deferred("add_child", tower_attack)
	weather_placement.call_deferred("add_child", wind)
	#weather_placement.add_child(wind)
