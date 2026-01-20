extends Button
@onready var scrollbar: MarginContainer = $"../../.."
@export var collapsed = false
var collapse_pos = Vector2(0, 135)
var collapse_speed = 1.2

func _ready() -> void:
	button_down.connect(_on_button_down)
	
func _on_button_down():
	var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	if !collapsed:
		tween.tween_property(scrollbar, "position", collapse_pos, collapse_speed)
		collapsed = true
	else:
		tween.tween_property(scrollbar, "position", Vector2(0, 0), collapse_speed)
		collapsed = false
	#print("pressed")
