extends Control
const MUSIC_IDX : int = 2
const SFX_IDX : int = 1
const MAX_DB : float = 0.0
const MIN_DB : float = -40.0
@export var music_volume : HSlider
@export var SFX_volume : HSlider




func _ready() -> void:
	SFX_volume.drag_ended.connect(_on_volume_change.bind(false))
	music_volume.drag_ended.connect(_on_volume_change)


func _on_volume_change(_value_changed: bool, is_music_volume:= true) -> void:
	if is_music_volume: 
		if music_volume.value == 0.0:
			AudioServer.set_bus_mute(MUSIC_IDX, true)
		else:
			AudioServer.set_bus_mute(MUSIC_IDX, false)
		var new_db : float = music_volume.value * (MAX_DB - MIN_DB) + MIN_DB
		AudioServer.set_bus_volume_db(MUSIC_IDX, new_db)
		
	
		
	else:
		if SFX_volume.value == 0.0:
			AudioServer.set_bus_mute(SFX_IDX, true)
		else:
			AudioServer.set_bus_mute(SFX_IDX, false)
		var new_db : float = SFX_volume.value * (MAX_DB - MIN_DB) + MIN_DB
		AudioServer.set_bus_volume_db(SFX_IDX, new_db)
		
		
