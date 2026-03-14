extends Node2D

# All const are general settings, statics are for every instance of trash wind


# DONT CHANGE THIS, basically prevents the trash from spawning too close to map border
const POS_OFFSET := Vector2(20,20)
# DONT CHANGE THIS, its the offset of the hitbox with the animation
const HITBOX_TRAVEL_DISTANCE : float = 46
## The max amount of pixels trash can travel
const MAX_TRAVEL_DISTANCE : float = 400
## The amount of time trash takes to reach its new location
const MAX_SPEED := 0.75 # Really fast
const MIN_SPEED := 2.5 # Really slow

# Default params for testing, gets overridden when called
static var duration : float = 30
static var trash_per_second : float = 20
static var direction : int = -1
static var min_pos : Vector2 = Vector2(-320,-180)
static var max_pos : Vector2 = Vector2(320, 180)

@onready var effect_timer : Timer = $EffectDuration
@onready var trash_container := $TrashWindContainer
@onready var trash : AnimatedSprite2D = $StartingTrash
@onready var hitbox : Area2D = $StartingTrash/TrashHitBox
@onready var spawn_timer := $SpawnTimer

var ran = RandomNumberGenerator.new()

func init(_duration : float, _trash_per_second : float, _direction : int, _min_pos : Vector2, _max_pos : Vector2) -> void:
	duration = _duration
	trash_per_second = _trash_per_second
	direction = _direction
	min_pos = _min_pos
	max_pos = _max_pos

func  _ready() -> void:
	effect_timer.start(duration)
	effect_timer.timeout.connect(_delete_weather)
	
	ran.randomize()
	if direction == -1:
		trash.flip_h = true
		hitbox.position = Vector2(46,0)
	min_pos += POS_OFFSET
	max_pos -= POS_OFFSET
	spawn_timer.start( 1.0 / trash_per_second)
	spawn_timer.timeout.connect(_spawn_trash)
	

func _spawn_trash() -> void:
	var new_trash : AnimatedSprite2D = trash.duplicate()
	var new_hitbox : Area2D = new_trash.get_child(0)
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_parallel()
	var speed := randf_range(MIN_SPEED, MAX_SPEED)
	new_trash.speed_scale = 1/speed
	
	
	var new_x : float = randf_range(min_pos.x, max_pos.x)
	var new_y : float = randf_range(min_pos.y, max_pos.y)
	new_trash.global_position = Vector2(new_x, new_y)
	#new_hitbox.global_position = new_trash.global_position
	trash_container.call_deferred("add_child", new_trash)
	if RandomNumberGenerator.new().randf() < 0.5:
		new_trash.play("BlackTrash")
	else:
		new_trash.play("WhiteTrash")
		#ran.randomize()

	tween.tween_property(new_trash, "global_position", Vector2(new_x + MAX_TRAVEL_DISTANCE * ran.randf() * direction, new_y), speed)
	tween.tween_property(new_hitbox, "position", new_hitbox.position + Vector2(HITBOX_TRAVEL_DISTANCE * direction, 0), speed/2)
	tween.play()
	tween.finished.connect(func():
		if is_instance_valid(new_trash):
			new_trash.queue_free()
	)
	
	
	
func _delete_weather() -> void:
	spawn_timer.timeout.disconnect(_spawn_trash)
	spawn_timer.start(MAX_SPEED)
	await spawn_timer.timeout
	queue_free()
