extends Node2D

const WEATHERS = {
	"Rain" : preload("res://scenes/Weather/rain_scene.tscn"),
	"Wind" : preload("res://scenes/Weather/wind_scene.tscn"),
	"RottingGrass" : preload("res://scenes/Weather/rotting_grass_scene.tscn"),
	"TrashWind" : preload("res://scenes/Weather/trash_wind_scene.tscn")
}
const WEATHER_ICONS := "res://scenes/Weather/weather_icons_scene.tscn"
var icon_container : GridContainer

## Emitted when a weather has ended. Use a string for the name of the weather ex. "Rain"
signal weather_ended(type : String, entity_type : String)
# duration, which can be modular (towers placed in map and base hp %)
const STAT_TYPES = StatChanger.Type
func _ready() -> void:
	weather_ended.connect(_end_weather)
	##z_index = 12
	##notify_property_list_changed()
	##self.ordering
	##self.z_index = 12
	##Node.z_index
	#z_index = 12
	#var weather_icons = load(WEATHER_ICONS).instantiate()
	#add_child(weather_icons)
	#icon_container = weather_icons.get_child(0)
	#print(icon_container)
	##pass

func spawn_rain(duration : float, buff_percent: float, weather_placement : Node2D):
	var rain = WEATHERS["Rain"].instantiate()
	rain.init(duration, buff_percent)
	#weather_placement.add_child(rain)
	#call_deferred("add_child", rain)
	weather_placement.call_deferred("add_child", rain)
	#icon_container.get_node("Rain").visible = true
	#weather_placement.get_node("WeatherIcons/GridContainer/Rain").visible = true

func spawn_wind(duration : float, buff_percent : float, debuff_percent : float, direction : int, weather_placement : Node2D,):
	var wind = WEATHERS["Wind"].instantiate()
	wind.init(duration, buff_percent, debuff_percent, direction)
	#map_area.call_deferred("add_child", tower_attack)
	weather_placement.call_deferred("add_child", wind)
	#weather_placement.add_child(wind)

func spawn_rotting_grass(duration : float, debuff_percent : float, weather_placement : Node2D):
	var rotting_grass = WEATHERS["RottingGrass"].instantiate()
	rotting_grass.init(duration, debuff_percent)
	weather_placement.call_deferred("add_child", rotting_grass)

func spawm_trash_wind(duration : float, trash_per_second : int, direction : int, min_pos : Vector2, max_pos : Vector2, weather_placement : Node2D):
	var trash_wind = WEATHERS["TrashWind"].instantiate()
	trash_wind.init(duration, trash_per_second, direction, min_pos, max_pos)
	weather_placement.call_deferred("add_child", trash_wind)

func _end_weather(weather_type : String, entity_type : String):
	#if is_tower_weather:
	var entities = get_tree().get_nodes_in_group(entity_type)
	for entity in entities:
		entity.weather_statuses.erase(weather_type)
