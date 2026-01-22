extends Node2D
signal gameplay_started
signal intermission_started
@onready var audio_player: AudioStreamPlayer = $AegisTracks
const title_song = preload("res://assets/music/Aegis Title Screen.mp3")
const lvl1_song = preload("res://assets/music/Aegis Level Music 1.mp3")

func _ready() -> void:
	SceneLoader.root = self
	# Just a one off thing, _current_scenes wont ever be refrenced again.
	# Since the game starts off with start_menu already loaded we assign it.
	SceneLoader._current_scenes["start_menu"] = self.get_child(0)
	SceneLoader.current_main_scene = "start_menu"
	gameplay_started.connect(play_lvl1_audio)
	intermission_started.connect(play_title_audio)
	
func play_lvl1_audio():
	audio_player.stream = lvl1_song
	audio_player.play()

func play_title_audio():
	audio_player.stream = title_song
	audio_player.play()
