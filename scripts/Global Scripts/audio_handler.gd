extends Node
var audio_player : AudioStreamPlayer
var audio_files_dict = {
	"confirm" : preload("res://assets/music/Confirm.mp3")
}
var audio_node_dict = {}

func _ready() -> void:
	for audio in audio_files_dict:
		audio_player = AudioStreamPlayer.new()
		audio_player.stream = audio_files_dict[audio]
		audio_player.volume_db = -10.0
		audio_player.bus = "sfx"
		audio_player.process_mode = PROCESS_MODE_ALWAYS
		add_child(audio_player)
		audio_node_dict.set(audio, audio_player)
