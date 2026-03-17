extends Node2D

const WEATHERS = {
	"Rain" : preload("res://scenes/Weather/rain_scene.tscn"),
	"Wind" : preload("res://scenes/Weather/wind_scene.tscn"),
	"RottingGrass" : preload("res://scenes/Weather/rotting_grass_scene.tscn"),
	"TrashWind" : preload("res://scenes/Weather/trash_wind_scene.tscn"),
	"AcidRain" : preload("res://scenes/Weather/acid_rain.tscn"),
	"HarshSun" : preload("res://scenes/Weather/harsh_sun_scene.tscn"),
}

const WEATHER_TEXTS : Dictionary[String, String] ={
	"Rain" : "Rain makes towers shoot {0}% faster",
	"Wind" : "Wind changes enemy\nspeed by {0}% or {1}% depending on direction",
	"RottingGrass" : "Rotting grass prevents placement and weakens\ntowers by {0}% if on it",
	"TrashWind" : "Trash blocks tower projectiles", # Not used cuz it never changes
	"AcidRain" : "Acid rain heals enemies\nby {0}hp every 0.5s",
	"HarshSun" : "Harsh sun reduces your visibility and tower\nrange by {0}%",
}

const WEATHER_ICONS := "res://scenes/Weather/weather_icons_scene.tscn"
static var weather_node : Node2D
var icon_container : GridContainer

## Emitted when a weather has ended. Use a string for the name of the weather ex. "Rain"
signal weather_ended(type : String, is_tower : bool)
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

func spawn_rain(duration : float, buff_percent: float, _weather_node : Node2D, _scale : float = 1.0):
	var rain = WEATHERS["Rain"].instantiate()
	rain.init(duration, buff_percent)
	rain.scale = Vector2.ONE * _scale
	_weather_node.call_deferred("add_child", rain)
	weather_node = _weather_node
	
	var icon : Icon = _weather_node.get_node("WeatherIcons/GridContainer/Rain")
	icon.visible = true
	icon.get_child(0).text = WEATHER_TEXTS["Rain"].format([int(buff_percent*-100)])

func spawn_wind(duration : float, buff_percent : float, debuff_percent : float, direction : int, _weather_node : Node2D, is_visible := true, min_pos := Vector2(-360,180), max_pos := Vector2(360,180)):
	var wind = WEATHERS["Wind"].instantiate()
	wind.init(duration, buff_percent, debuff_percent, direction, is_visible, min_pos, max_pos)
	_weather_node.call_deferred("add_child", wind)
	weather_node = _weather_node
	
	var icon : Icon = _weather_node.get_node("WeatherIcons/GridContainer/Wind")
	icon.visible = true
	icon.get_child(0).text = WEATHER_TEXTS["Wind"].format([int(buff_percent*100),int(debuff_percent*100)])

func spawn_rotting_grass(duration : float, debuff_percent : float, _weather_node : Node2D):
	var rotting_grass = WEATHERS["RottingGrass"].instantiate()
	rotting_grass.init(duration, debuff_percent)
	_weather_node.call_deferred("add_child", rotting_grass)
	
	weather_node = _weather_node
	
	var icon : Icon = _weather_node.get_node("WeatherIcons/GridContainer/RottingGrass")
	icon.visible = true
	icon.get_child(0).text = WEATHER_TEXTS["RottingGrass"].format([int(debuff_percent*100)])

func spawn_trash_wind(duration : float, trash_per_second : int, direction : int, min_pos : Vector2, max_pos : Vector2, _weather_node : Node2D):
	var trash_wind = WEATHERS["TrashWind"].instantiate()
	trash_wind.init(duration, trash_per_second, direction, min_pos, max_pos)
	_weather_node.call_deferred("add_child", trash_wind)
	
	weather_node = _weather_node
	
	var icon : Icon = _weather_node.get_node("WeatherIcons/GridContainer/TrashWind")
	icon.visible = true
	#icon.get_child(0).text = WEATHER_TEXTS["TrashWind"]

func spawn_acid_rain(duration : float, buff_percent : float, _weather_node : Node2D, _scale : float = 1.0) -> void:
	var acid_rain = WEATHERS["AcidRain"].instantiate()
	acid_rain.init(duration, buff_percent)
	acid_rain.scale = Vector2.ONE * _scale
	_weather_node.call_deferred("add_child", acid_rain)
	
	weather_node = _weather_node
	
	var icon : Icon = _weather_node.get_node("WeatherIcons/GridContainer/AcidRain")
	icon.visible = true
	icon.get_child(0).text = WEATHER_TEXTS["AcidRain"].format([buff_percent*-1])
	
	
func spawn_harsh_sun(duration : float, debuff_percent : float, _weather_node : Node2D) -> void:
	var harsh_sun = WEATHERS["HarshSun"].instantiate()
	harsh_sun.init(duration, debuff_percent)
	harsh_sun.scale = Vector2.ONE * scale
	_weather_node.call_deferred("add_child", harsh_sun)
	
	weather_node = _weather_node
	
	var icon : Icon = _weather_node.get_node("WeatherIcons/GridContainer/HarshSun")
	icon.visible = true
	icon.get_child(0).text = WEATHER_TEXTS["HarshSun"].format([int(debuff_percent*100)])

#func _spawn_normal_weather(weather_type : String, duration : float, stat_percent : float, weather_placement : Node2D) -> void:
	#var weather = WEATHERS[weather_type].instantiate()
	#weather.init(duration, stat_percent)
	#weather_placement.call_deferred("add_child", weather)
	#weather_placement.get_node("WeatherIcons/GridContainer/"+weather_type).visible = true
	#weather_node = weather_placement

func _end_weather(weather_type : String, is_tower : bool):
	#if is_tower_weather:
	if is_tower:
		var towers = get_tree().get_nodes_in_group("tower")
		#print("THIS IS TOWER: ", towers,"----------------")
		for tower : Tower in towers:
			#if tower.weather_statuses.has(weather_type):
			tower.weather_statuses.erase(weather_type)
	weather_node.get_node("WeatherIcons/GridContainer/"+weather_type).visible = false
