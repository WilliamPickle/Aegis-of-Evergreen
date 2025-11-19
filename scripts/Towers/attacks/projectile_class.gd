extends Area2D
class_name Projectile

enum Attack_Type{
	BASIC,
	SPLASH,
}
@export var type : Attack_Type
@export var speed : float
@export var trans_type : Tween.TransitionType
## The max amount of collisions the attack may have
@export var max_hits : int

#@onready var despawn_timer : Timer = $DespawnTime
var tower_area : Area2D
var target_enemy : Enemy


func _ready() -> void:
	# face the enemy
	rotation = global_position.angle_to(target_enemy.global_position)
	#spawn at the tower
	global_position = tower_area.global_position
	
	# get the direction to where the attack is aimed at
	var direction = ((global_position - target_enemy.global_position) * -1).normalized()
	var tween = create_tween().set_trans(trans_type)
	tween.tween_property(self,"global_position",direction * 100 + tower_area.global_position,speed)
	area_entered.connect(_on_hit)
	tween.play()
	tween.finished.connect(delete)

func delete():
	queue_free()

# IGNORE THIS FOR NOW
func _on_hit(area) -> void:
	max_hits -= 1
	if max_hits <= 0:
		queue_free()
