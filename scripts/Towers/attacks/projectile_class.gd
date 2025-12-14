extends Area2D
class_name Projectile

enum Type{
	NONE, # ONLY FOR ENEMIES
	BLUNT,
	EXPLOSIVE,
}
@export var type : Type = Type.BLUNT
@export var speed : float
@export var trans_type : Tween.TransitionType
## The max amount of collisions the attack may have
@export var max_hits : int
@export var despawn_distance : float
@export var debuff_type : Debuff.Type

var tower : Attacker
var tower_range : Area2D
var target_enemy : Enemy


func _ready() -> void:
	#spawn at the tower
	global_position = tower_range.global_position
	# face the enemy
	var newPos : Vector2 = target_enemy.global_position - global_position
	rotation = atan2(newPos.y, newPos.x)
	
	# get the direction to where the attack is aimed at
	var direction : Vector2 = ((global_position - target_enemy.global_position) * -1).normalized()
	var attack_length = direction * (tower_range.get_child(0).shape.radius + despawn_distance)
	var tween = create_tween().set_trans(trans_type)
	tween.tween_property(self, "global_position", attack_length + tower_range.global_position, speed)
	area_entered.connect(_on_hit)
	tween.play()
	tween.finished.connect(func():
			queue_free()
	)


# WILL BE CHANGED LATER ONCE HEALTH
# AND OTHER STUFF IS ADDED
func _on_hit(enemy : Enemy) -> void:
	#if enemy == null:
		#return
	#enemy.cur_health -= tower.cur_damage
	#enemy.health_changed.emit()
	enemy.apply_damage(tower.cur_damage, type)
	max_hits -= 1
	if max_hits <= 0:
		queue_free()
