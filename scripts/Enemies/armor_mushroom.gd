extends Enemy
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var phase_1_collision: CollisionShape2D = $phase1collision
@onready var phase_2_collision: CollisionShape2D = $phase2collision
@onready var real_original_speed = original_speed
var phase_change_percent: float = 0.5
var in_phase_2: bool = false
var speed_multiplier = 3

	
func enter_phase_2():
	in_phase_2 = true
	phase_1_collision.visible = false
	phase_2_collision.visible = true
	sprite.play("phase_change")
	original_speed = 0
	speed = original_speed
	await sprite.animation_finished
	sprite.play("phase2")
	original_speed = real_original_speed * speed_multiplier
	speed = original_speed

func apply_damage(damage : float, damage_type):
	super.apply_damage(damage, damage_type)
	if cur_health <= max_health * phase_change_percent and !in_phase_2:
		enter_phase_2()
