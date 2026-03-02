extends Node2D

const MAX_TRAVEL_DISTANCE = 200
#@onready var tween := create_tween()
@onready var animation := $AnimatedSprite2D
var r = RandomNumberGenerator.new()

func _ready() -> void:
	r.randomize()
	animation.animation_finished.connect(func():
		animation.global_position = Vector2(r.randi_range(-300,300), r.randi_range(-160,160))
		#print("Global Pos: ", animation.global_position)
		var travel_destination : Vector2 = animation.global_position + (Vector2(MAX_TRAVEL_DISTANCE * r.randf(), 0))
		#print("Travel destination: ", travel_destination)
		#print("New end pos: ", animation.global_position + travel_destination)
		var tween := create_tween()
		tween.tween_property(animation,"global_position", travel_destination, 1)
		tween.play()
		animation.play("default")
	)
