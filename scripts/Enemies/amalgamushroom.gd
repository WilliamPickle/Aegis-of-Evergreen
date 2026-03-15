extends Enemy
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var move_timer: Timer = $MoveTimer
const phase_change_percent : float = 0.5
const phase_health : Array[float] = [400, 750]
const phase_speed : Array[float] = [-0, -0]
const phase_collider_r : Array[float] = [9, 15]
const phase_move_frame : Array[float] = [8, 6]
const fps : Array[float] = [10, 12]
var cur_phase : int = 1
	
func apply_damage(damage : float, damage_type):
	super.apply_damage(damage, damage_type)
	if cur_health <= max_health * phase_change_percent and cur_phase < 3:
		change_phase()
		
func change_phase() -> void:
	sprite.animation_looped.disconnect(move)
	speed_variance = -1
	cur_phase += 1
	max_health = phase_health[cur_phase - 2]
	cur_health = max_health
	collider.shape.radius = phase_collider_r[cur_phase - 2]
	sprite.play("phase" + str(cur_phase) + " transition")
	await sprite.animation_finished
	sprite.play("phase"  + str(cur_phase))
	sprite.animation_finished.connect(move)
	sprite.animation_looped.connect(move)

	
func move() -> void:
	print("frame: ", sprite.frame)
	move_timer.start(1 / fps[cur_phase - 2] * phase_move_frame[cur_phase - 2])
	speed_variance = -1
	await move_timer.timeout
	speed_variance = phase_speed[cur_phase - 2]
