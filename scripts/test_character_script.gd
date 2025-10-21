extends Node2D

@onready var map_area : Area2D = $Area2D
var nodes = preload("res://scenes/tower.tscn")
var newTower : Tower
var can_follow = false

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_E and not can_follow:
			can_follow = true
			newTower = nodes.instantiate()
			newTower.map_area = map_area
			map_area.add_child(newTower)
			
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and can_follow:
			var can_place = newTower.place_tower()
			if not can_place:
				return
			newTower = null
			can_follow = false
