extends Node2D
signal map1_started
signal map2_started
signal map3_started
signal intermission_started
@onready var audio_player: AudioStreamPlayer = $AegisTracks
const title_song := preload("res://assets/music/Aegis Title Screen.mp3")
const lvl1_song := preload("res://assets/music/Aegis Level Music 1.mp3")
const lvl2_song := preload("res://assets/music/Aegis Lvl Two - Decay.mp3")
const playlist : Array = [
	lvl1_song,
	lvl2_song,
]
var playlist_index : int = 0

func _ready() -> void:
	SceneLoader.root = self
	# Just a one off thing, _current_scenes wont ever be refrenced again.
	# Since the game starts off with start_menu already loaded we assign it.
	SceneLoader._current_scenes["start_menu"] = self.get_child(0)
	SceneLoader.current_main_scene = "start_menu"
	#map1_started.connect(play_audio.bind(title_song))
	map2_started.connect(play_audio.bind(lvl1_song))
	map3_started.connect(play_audio.bind(lvl2_song))
	audio_player.finished.connect(replay)

	
func play_audio(audio):
	audio_player.stream = audio
	audio_player.play()

func replay():
	audio_player.play()
