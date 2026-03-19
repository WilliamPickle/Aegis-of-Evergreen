extends Button

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@export var speed_multiplier: float = 2
var normal_style: StyleBox = preload("res://assets/sprites/icons and buttons/fast_forward_ui_normal.tres")
var highlight_style: StyleBox = preload("res://assets/sprites/icons and buttons/fast_forward_ui_highlight.tres")
var fast_forward_on: bool = false

func _ready() -> void:
	button_down.connect(toggle_fast_forward)
	
func toggle_fast_forward():
	if !fast_forward_on:
		Engine.time_scale = speed_multiplier
		#modulate = Color(0.75, 0.75, 0.75)
		add_theme_stylebox_override("normal", highlight_style)
		$"2x".visible = true
		fast_forward_on = true
	elif fast_forward_on:
		Engine.time_scale = 1
		#modulate = Color(1, 1, 1)
		add_theme_stylebox_override("normal", normal_style)
		$"2x".visible = false
		fast_forward_on = false
	audio.play()
