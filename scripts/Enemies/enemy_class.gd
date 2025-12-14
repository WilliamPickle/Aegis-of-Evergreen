class_name Enemy
extends Area2D

# enemy based variables
@export var enemy_sprite : Node2D
@export var enemy_node : Node2D
@export var speed = 0.02
@export var resistance : Projectile.Type = Projectile.Type.NONE

# hp bar variables
signal health_changed
@export var health_bar : Sprite2D
@export var max_health : float
var cur_health : float
var bar_length : float
@onready var button: Button = $Button
# used to redraw health bar with updated health

# path based variables
var path : PathFollow2D
var path_position = null
var cur_position = 0
var prev_position = 0

# for debugging
@onready var timer: Timer = $Timer

func _ready() -> void:
	button.button_down.connect(toggle_health_bar)
	health_changed.connect(draw_health)
	cur_health = max_health
	bar_length = health_bar.texture.get_width() * health_bar.scale.x
	path = enemy_node.get_parent()
	
	
	
# progresses enemy along a path.
# automatically deletes enemy and path when it reaches the end
func move_on_path(delta) -> void:
	if  path.progress_ratio >= 1:
		path.queue_free()
		enemy_sprite.queue_free()

	path_position = path.get_global_position().x
	prev_position = cur_position
	path.progress_ratio += speed * delta
	cur_position = path_position
	
	if (cur_position - prev_position < 0):
		enemy_sprite.flip_h = false
	else:
		enemy_sprite.flip_h = true

func apply_damage(damage : float, damage_type : Projectile.Type):
	var damage_percent = 1
	if damage_type == resistance:
		# ADD SOME CALCULATIONS HERE WITH damage_percent
		pass
	cur_health -= damage * damage_percent
	if cur_health <= 0.0:
		queue_free()
		return
	draw_health()

func draw_health():
	if cur_health <= 0.0:
		queue_free()
		return
	health_bar.scale.x = cur_health / max_health
	health_bar.position.x = -(bar_length - health_bar.texture.get_width() * health_bar.scale.x) / 2
	
func toggle_health_bar():
	health_bar.get_parent().visible = !health_bar.get_parent().visible
	
# temporary debugging function for timer node
func delay(delay_time) -> void:
	timer.wait_time = delay_time
	timer.start()
	await timer.timeout

func _process(delta: float) -> void:
	move_on_path(delta)
