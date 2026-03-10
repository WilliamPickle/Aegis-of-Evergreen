extends Node2D
class_name RottingGrass

static var duration : float = 5
static var debuff_percent : float = -0.5

@onready var effect_timer : Timer = $EffectDuration
@onready var grass_container : Node2D = $GrassContainer

func init(_duration : float, _debuff_percent : float) -> void:
	duration = _duration
	debuff_percent = _debuff_percent

func _ready() -> void:
	grass_container.global_position += Vector2.UP
	grass_container.force_update_transform()
	for grass : AnimatedSprite2D in grass_container.get_children():
		grass.play("spawn")
		grass.animation_finished.connect(func():
			grass.play("idle")
			var area : Area2D = grass.get_child(0)
			_on_tower_present(area.get_overlapping_areas())
		)
		#await get_tree().physics_frame
		
	effect_timer.start(duration)
	effect_timer.timeout.connect(_delete_rotting_grass)

func _on_tower_present(towers : Array[Area2D]):
	print("Was called with: ", towers)
	for tower : Tower in towers:
		print("Tower was present in area")
		
func _delete_rotting_grass() -> void:
	var final_grass : AnimatedSprite2D
	for grass : AnimatedSprite2D in grass_container.get_children():
		grass.play("despawn")
		final_grass = grass
	await final_grass.animation_finished
	queue_free()
