extends Area2D
class_name Projectile

enum Type{
	NONE, # ONLY FOR ENEMIES
	BLUNT,
	EXPLOSIVE,
}
@export var face_enemy : bool = true

# Class shared vars
@export var offset : Vector2 = Vector2.ZERO

	# Data
static var Game_Data = JSON.parse_string(FileAccess.get_file_as_string("res://Game Data.json"))
@export var data_resource : DataResource = DataResource.new()
@onready var object_data = Game_Data[data_resource.class_type][data_resource.object]
	# Projectile class stats
@onready var type : String = object_data["type"]
@onready var travel_time : float = object_data["travel_time"]
@onready var pierce_cap : int = object_data["pierce_cap"]
@onready var debuff_tString : String = object_data["debuff_type"]
	# Projectile refrences
var tower : Attacker
var tower_range : Area2D
var target_enemy : Enemy

# Projectile exclusive vars
## After projectile leaves the tower's range, despawn after a set amount of pixels later.
## _despawn_distance may be a float value or null.
@onready var _despawn_distance = object_data.get("despawn_distance") #object_data["despawn_distance"]\
#if "despawn_distance" in object_data else null

func _ready() -> void:
	global_position = tower.global_position + offset
	# face the enemy
	if face_enemy:
		snap_to_enemy()
	
	# get the direction to where the attack is aimed at
	var direction : Vector2 = ((global_position - target_enemy.global_position) * -1).normalized()
	
	#var range_radius : float = tower.range
	var attack_length : Vector2 = direction * (tower.range + _despawn_distance)
		
	var tween = create_tween()
	tween.tween_property(self, "global_position", attack_length + tower_range.global_position, travel_time)
	area_entered.connect(on_hit)
	tween.play()
	tween.finished.connect(on_met_target)

func snap_to_enemy() -> void:
	var newPos : Vector2 = target_enemy.global_position - global_position
	rotation = atan2(newPos.y, newPos.x)

func on_hit(enemy : Enemy) -> void:
	#if enemy == null:
		#return
	#enemy.cur_health -= tower.cur_damage
	#enemy.health_changed.emit()
	if !is_instance_valid(tower):
		queue_free()
		return
	
	enemy.apply_damage(tower.cur_damage, Type.BLUNT)
	pierce_cap -= 1
	if pierce_cap <= 0:
		queue_free()
## This functions holds the logic for when the projectile
## has met its life span.
func on_met_target() -> void:
	queue_free()
