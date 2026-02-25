extends Tower
class_name Flower

const STAT_TYPES = StatChanger.Type


# Flower specific stats
@onready var enemy_cap : int = object_data["enemy_cap"][0]
@onready var buff_type : String = object_data["buff_type"][0]
@onready var buff_multiplier : float = object_data["buff_multiplier"][0]
@onready var buff_duration : int = object_data["buff_duration"][0]



@onready var _attack_cooldown : Timer = $AttackCoolDOwn
@onready var VFX := $VFX

var target_enemies : Array[Enemy]
var target_towers : Array[Tower]


func _ready() -> void:
	super()
	tower_placed.connect(func():
		sprite.play("idle_"+str(level))
		_attack_cooldown.autostart = true
		_attack_cooldown.start(object_data["attack_speed"][level])
		_attack_cooldown.timeout.connect(_enemy_logic)
		_attack_cooldown.timeout.connect(_support_actions)
	)

func _support_actions():
	var entities := range_area.get_overlapping_areas()
	VFX.play("support_" + str(level))
	var start_time = Time.get_ticks_usec()
	for entity in entities:
		if entity is Enemy:
			target_enemies.append(entity)
		if entity is Tower:
			var children = entity.get_children()
			for child in children:
				if child is StatChanger:
					child.clense_stat(0.25)
	var total_time = Time.get_ticks_usec() - start_time
	print("Took total of: ", total_time," microseconds")
	
func _enemy_logic():
	print("Hey ran too!!!!")
	
func upgrade_tower() -> void:
	super()
	sprite.play("idle_" + str(level))
