extends Node

# duration, which can be modular (towers placed in map and base hp %)
const STAT_TYPES = StatChanger.Type

func spawn_rain(duration : float, buff_percent: float, map_area : Area2D):
	var test = StatChanger.new()
	test.initialize_variables("We","Weather",STAT_TYPES.NONE, buff_percent,10)
	for child in map_area.get_children():
		if child is Tower:
			var rain = StatChanger.new()
			rain.initialize_variables(child, "Weather", STAT_TYPES.ATK_COOLDOWN, 0.2,duration)
