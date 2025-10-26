extends Button
class_name Tower_Placement

const towers : Dictionary = {
	"Tower" = preload("res://scenes/Towers/Tower.tscn"),
}
static var is_placing := false
static var new_tower : Tower
@export var map_area : Area2D
@export var tower_type : String

func _ready() -> void:
	button_down.connect(place_tower)
	
func place_tower() -> void:
	if is_placing:
		return
	is_placing = true
	new_tower = towers[tower_type].instantiate()
	new_tower.map_area = map_area
	map_area.add_child(new_tower)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and is_placing:
			var can_place : bool = new_tower.place_tower()
			if not can_place: return
			new_tower = null
			is_placing = false
		elif event.button_index == MOUSE_BUTTON_RIGHT and is_placing:
			new_tower.queue_free()
			new_tower = null
			is_placing = false	
