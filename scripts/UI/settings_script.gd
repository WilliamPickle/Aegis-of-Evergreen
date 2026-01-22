extends Control
const MUSIC_IDX : int = 2
const SFX_IDX : int = 1
const MAX_DB : float = 0.0
const MIN_DB : float = -40.0
@export var music_volume : HSlider
@export var SFX_volume : HSlider
static var music_value: float = 1.0
static var sfx_value: float = 1.0




func _ready() -> void:
	SFX_volume.drag_ended.connect(_on_volume_change.bind(false))
	music_volume.drag_ended.connect(_on_volume_change)
	music_volume.value = music_value
	SFX_volume.value = sfx_value


func _on_volume_change(_value_changed: bool, is_music_volume:= true) -> void:
	if is_music_volume: 
		if music_volume.value == 0.0:
			AudioServer.set_bus_mute(MUSIC_IDX, true)
		else:
			AudioServer.set_bus_mute(MUSIC_IDX, false)
		var new_db : float = music_volume.value * (MAX_DB - MIN_DB) + MIN_DB
		AudioServer.set_bus_volume_db(MUSIC_IDX, new_db)
		music_value = music_volume.value
		
	
		
	else:
		if SFX_volume.value == 0.0:
			AudioServer.set_bus_mute(SFX_IDX, true)
		else:
			AudioServer.set_bus_mute(SFX_IDX, false)
		var new_db : float = SFX_volume.value * (MAX_DB - MIN_DB) + MIN_DB
		AudioServer.set_bus_volume_db(SFX_IDX, new_db)
		sfx_value = SFX_volume.value
		
		
