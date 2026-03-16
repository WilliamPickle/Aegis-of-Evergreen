extends Area2D
@onready var sprite: AnimatedSprite2D = $sprite
@onready var timer: Timer = $Timer
@onready var duration : float = 10
@onready var heal_amount : float = 1

func _ready() -> void:
	await sprite.animation_finished
	sprite.play("default")
	timer.timeout.connect(despawn)
	timer.start(duration)
	
	area_entered.connect(heal_target)

func despawn() -> void:
	sprite.play("outro")
	await sprite.animation_finished
	queue_free()
	
func heal_target(target : Enemy) -> void:
	if target.cur_health + heal_amount >= target.max_health:
		target.cur_health = target.max_health
	else:
		target.cur_health += heal_amount
	target.draw_health()
