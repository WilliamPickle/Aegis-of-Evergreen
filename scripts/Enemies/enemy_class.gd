class_name Enemy
extends Area2D
signal reached_end

# enemy based variables
@export var enemy_sprite : Node2D
@export var speed = 0.015
@export var resistance : Projectile.Type = Projectile.Type.NONE
## Used to calculate damage it does against the base. 
## Formula is cur_health * base_damage_ratio
@export var base_damage_ratio : float = 0.5
@onready var enemy_node = self
var sprite_reversed = false

# hp bar variables
@export var hp_button: Button
## health_bar should be the child of the hp container.
## it's the green bar that contains the actual health.
@export var health_bar : Sprite2D
@export var max_health : float = 4
var cur_health : float
var bar_length : float
# used to redraw health bar with updated health

# path based variables
var path : PathFollow2D
var path_position = null
var cur_position = 0
var prev_position = 0

func _ready() -> void:
	hp_button.button_down.connect(toggle_health_bar)
	cur_health = max_health
	bar_length = health_bar.texture.get_width() * health_bar.scale.x
	path = enemy_node.get_parent()
	enemy_node.z_index = 4
	enemy_node.collision_layer = 2
	enemy_node.collision_mask = 2
	if enemy_sprite.flip_h == true:
		sprite_reversed = true
	
	
	
# progresses enemy along a path.
# automatically deletes enemy and path when it reaches the end
func move_on_path(delta) -> void:
	if  path.progress_ratio >= 1:
		path.queue_free()
		enemy_sprite.queue_free()
		if cur_health > 0:
			emit_signal("reached_end")

	path_position = path.get_global_position().x
	prev_position = cur_position
	path.progress_ratio += speed * delta
	cur_position = path_position
	
	if (cur_position - prev_position < 0):
		if !sprite_reversed:
			enemy_sprite.flip_h = false
		else:
			enemy_sprite.flip_h = true
	else:
		if !sprite_reversed:
			enemy_sprite.flip_h = true
		else:
			enemy_sprite.flip_h = false

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

func _process(delta: float) -> void:
	move_on_path(delta)
