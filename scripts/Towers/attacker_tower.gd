extends Tower
class_name Attacker

## Possible target types.
enum Target{
	FIRST,
	LAST,
}

@export_subgroup("Stats")
@export var damage : Array[float] = [0.0, 0.0, 0.0]
@export var piercing : Array[float] = [0.0, 0.0, 0.0]

@onready var range_area : Area2D = $Range
@onready var _attack_cooldown : Timer = $AttackCoolDOwn

# Randomizing the target type for now.
var target_type = Target.values()[randi_range(0, Target.size()-1)]
# List of enemies in tower area
var _enemies : Array[Area2D] = []
# Current enemy tower does damage to
var targeted_enemy : Area2D

func _ready() -> void:
	super._ready()
	_attack_cooldown.timeout.connect(update_enemy_list)
	# Once tower is placed we can start attacking
	tower_placed.connect(func():
		print("Signal Connected")
		_attack_cooldown.autostart = true
		_attack_cooldown.start()
	)

# Only for debugging
func _draw() -> void:
	super._draw()
	if targeted_enemy != null:
		draw_line(Vector2.ZERO, (global_position - targeted_enemy.global_position)*-1, Color(0,0,0), 2)

# Just for visual will be deleted later.
func _physics_process(delta: float) -> void:
	if targeted_enemy != null:
		queue_redraw()

# This is to be defined by a sub class
func attack():
	pass

# Set the _enemies list to the overlapping areas
# can be removed due to only using _enemies once.
func update_enemy_list() -> void:
	_enemies = range_area.get_overlapping_areas()
	# If tower tried to attack and has no enemies to target
	# Stop the timer and use regular area_entered function
	if _enemies.size() == 0:
		print("No enmies detected when attacking")
		_attack_cooldown.stop()
		range_area.area_entered.connect(first_enemy_entered)
		targeted_enemy = null
	# Set to the corresponding enemy
	else:
		#print("Constant enemy detection")
		set_target()

## When tower checks for enemies in its range, and detects 0,
## the tower will use defualt area_entered signal.
func first_enemy_entered(enemy : Area2D):
	# Disable as now there is an enemy to detect
	range_area.area_entered.disconnect(first_enemy_entered)
	# Cool down already ran previously, so we are okay to
	# perform an immidiate attack. 
	attack()
	# Star the timer again.
	_attack_cooldown.start()

## Finds and sets the correct enemy to target.
func set_target() -> void:
	# Place holder
	var _chosen_enemy = _enemies[0]
	
	# If/elif would work, but people seem to recommend math
	# statements for these type of scenarios.
	match target_type:
		# For first and last we get the parent and find the
		# lowest/highest progres ratio
		Target.FIRST:
			for enemy in _enemies:
				var path_follow : PathFollow2D = enemy.get_parent()
				if path_follow.progress_ratio > _chosen_enemy.get_parent().progress_ratio:
					_chosen_enemy = enemy
		Target.LAST:
			for enemy in _enemies:
				var path_follow : PathFollow2D = enemy.get_parent()
				if path_follow.progress_ratio < _chosen_enemy.get_parent().progress_ratio:
					_chosen_enemy = enemy
	targeted_enemy = _chosen_enemy
