extends Control
# Note that what activates this scene is the base_class script
# Visbility_changed happens inside of the pause global script

@export var animation_duration = 1.2
@onready var continue_button: Icon = $"continue button"

var original_position = Vector2(0, -519.0)
var center_position = Vector2(0, 0)

func _ready() -> void:
	continue_button.button_down.connect(func(): 
		PauseUi.toggle_pause(SceneLoader._current_scenes["win_ui"])
		SceneLoader.delete_scene("win_ui")
		get_parent().queue_free()
		)
	Engine.time_scale = 1
	visibility_changed.connect(play_animation)
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", center_position, animation_duration)

func play_animation() -> void:
	Engine.time_scale = 1
	position = original_position
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", center_position, animation_duration)
