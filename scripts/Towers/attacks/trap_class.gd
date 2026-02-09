extends Area2D
class_name Trap

# Data
static var Game_Data = JSON.parse_string(FileAccess.get_file_as_string("res://Game Data.json"))
@export var data_resource : DataResource = DataResource.new()
@onready var object_data = Game_Data[data_resource.class_type][data_resource.object]

# Trap class stats
@onready var type : String = object_data["type"]
@onready var pierce_cap : int = object_data["pierce_cap"]
@onready var lifespan : float = object_data["lifespan"]
@onready var debuff_tString : String = object_data["debuff_type"]
@onready var ticks : float = object_data["dot_ticks"]
@onready var dot_damage : float = object_data["dot_damage"]

# Child nodes
@onready var sprite : AnimatedSprite2D = $Image
@onready var timer : Timer = $Timer

var has_hit : Array[Enemy]

# Tower refrences
var tower : Druid
#var target_enemy : Enemy

func _ready():
	sprite.play("spawning")
	sprite.animation_finished.connect(func():
		sprite.play("idle")
	)
	timer.start(lifespan)
	#area_exited.connect(_on_hit)
	area_entered.connect(_on_hit)
	
	timer.timeout.connect(func():
		_despawn()
	)



func _on_hit(enemy : Enemy) -> void:
	if enemy in has_hit:
		print("WAS HIT")
		return
	has_hit.append(enemy)
	if !is_instance_valid(tower):
		queue_free()
	elif pierce_cap > 0:
		enemy.apply_damage(tower.cur_damage, type)
		if debuff_tString != "none":
			var stat_changer := StatChanger.new()
			stat_changer.initialize_variables(enemy, name + enemy.name, StatChanger.Type.DOT, dot_damage, ticks)
			enemy.add_child(stat_changer)
		pierce_cap -= 1
		#print("Applied dmg to: ", enemy)
	else:
		_despawn()

func _despawn() -> void:
	area_entered.disconnect(_on_hit)
	sprite.play_backwards("spawning")
	await sprite.animation_finished
	queue_free()
