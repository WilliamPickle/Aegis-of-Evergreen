extends Projectile
class_name Splash

# Splash exclusive stats
@onready var splash_area : Area2D = $SplashArea
@onready var splash_radius = object_data["splash_radius"]
@onready var zone_sizes : Array = object_data["zone_sizes"]
@onready var zone_damages : Array = object_data["zone_damages"]
@onready var pierce_damage : float = object_data["pierce_damage"]
@onready var splash_cap : int = object_data["splash_cap"]

@onready var zone_1 = splash_radius * zone_sizes[0]
@onready var zone_2 = splash_radius * (zone_sizes[1] + zone_sizes[0])

@onready var explosionVFX : AnimatedSprite2D = $explosionVFX

#func _ready() -> void:
	#if face_enemy:
		#snap_to_enemy()
	#
	#var tween = create_tween()
	#tween.tween_property(self, "global_position", target_enemy.global_position, travel_time)
	#area_entered.connect(on_hit)
	#tween.play()
	#tween.finished.connect(on_met_target)
	
func _ready():
	$SplashArea/SplashShape.shape.radius = splash_radius
	super._ready()

func on_hit(enemy : Enemy) -> void:
	enemy.apply_damage(tower.cur_damage * pierce_damage, type)
	
	pierce_cap -= 1
	if pierce_cap <= 0:
		area_entered.disconnect(on_hit)
		on_met_target()

func on_met_target() -> void:
	tween.stop()
	var enemies = splash_area.get_overlapping_areas()
	var sorted_enemies : Dictionary[float,Enemy]
	for enemy in enemies:
		sorted_enemies[global_position.distance_to(enemy.global_position)] = enemy
	sorted_enemies.sort()
	
	var distances : Array[float] = sorted_enemies.keys()
	var enemies_to_dmg : int = splash_cap if splash_cap <= distances.size() else distances.size()
	
	#if distances.size() < splash_cap:
		#enemies_to_dmg = distances.size()
	print("\n","NEW SPLASH")
	for i in range(enemies_to_dmg):
		var distance = distances[i]
		var cur_enemy : Enemy = sorted_enemies[distance]
		var cur_zone : int
		
		if distance <= zone_1:
			cur_zone = 0
		elif distance <= zone_2:
			cur_zone = 1
		else:
			cur_zone = 2
		print("targeted:",distance,", Zone:", cur_zone, ", DMG:",tower.cur_damage * zone_damages[cur_zone], ", Raw Damage: ", tower.cur_damage)
		cur_enemy.apply_damage(tower.cur_damage * zone_damages[cur_zone], type)
		
	$AnimatedSprite2D.visible = false
	explosionVFX.global_rotation = 0
	explosionVFX.visible = true
	explosionVFX.play("default")
	await explosionVFX.animation_finished
	queue_free()
