extends Node2D

const POS_OFFSET := Vector2(20,20)
const MAX_TRAVEL_DISTANCE : float = 200
const HITBOX_TRAVEL_DISTANCE : float = 46

static var duration : float = 30.0
static var trash_per_second : float = 10
static var direction : int = 1
static var min_pos : Vector2 = Vector2(-320,-180)
static  var max_pos : Vector2 = Vector2(320, 180)

#static var 

@onready var trash_container := $TrashWindContainer
@onready var trash : AnimatedSprite2D = $StartingTrash
@onready var hitbox : Area2D = $StartingTrash/TrashHitBox
@onready var spawn_timer := $SpawnTimer

var ran = RandomNumberGenerator.new()

func init(_duration : float, _trash_per_second : float, _direction : int, _min_pos : Vector2, _max_pos : Vector2) -> void:
	duration = _duration
	trash_per_second = _trash_per_second
	direction = _direction

func  _ready() -> void:
	ran.randomize()
	if direction == -1:
		trash.flip_h = true
		hitbox.position = Vector2(46,0)
	min_pos += POS_OFFSET
	max_pos -= POS_OFFSET
	spawn_timer.start( 1.0 / trash_per_second)
	spawn_timer.timeout.connect(_spawn_trash)
	

func _spawn_trash() -> void:
	var new_trash := trash.duplicate()
	var new_hitbox : Area2D = new_trash.get_child(0)
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_parallel()
	var speed := randf_range(0.75, 2.5)
	new_trash.speed_scale = 1/speed
	
	
	var new_x : float = randf_range(min_pos.x, max_pos.x)
	var new_y : float = randf_range(min_pos.y, max_pos.y)
	#var new_pos : Vector2 = Vector2(new_x, new_y)
	new_trash.global_position = Vector2(new_x, new_y)
	#new_hitbox.global_position = new_trash.global_position
	trash_container.call_deferred("add_child", new_trash)
	#trash_container.call_deferred("add_child", new_hitbox)
	tween.tween_property(new_trash, "global_position", Vector2(new_x + MAX_TRAVEL_DISTANCE * ran.randf() * direction, new_y), speed)
	
	tween.tween_property(new_hitbox, "position",new_hitbox.position + Vector2(HITBOX_TRAVEL_DISTANCE * direction, 0), speed/2)
	tween.play()
	tween.finished.connect(func():
		new_trash.queue_free()
	)
	
func _delete_weather() -> void:
	pass
