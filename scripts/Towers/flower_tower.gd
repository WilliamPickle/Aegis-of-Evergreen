extends Tower
class_name Flower

const MONEY_MULT := StatChanger.Type.MONEY_MULT
const BUFF_VFX_FPATH : String = "res://assets/sprites/towers/flower_buff_sfx.tres"
const POS_OFFSET := Vector2(0, -14)


# Flower specific stats
@onready var enemy_cap : int = object_data["enemy_cap"][0]
@onready var buff_type : String = object_data["buff_type"][0]
@onready var buff_multiplier : float = object_data["buff_multiplier"][0]
@onready var buff_duration : int = object_data["buff_duration"][0]
@onready var clense_percent : float = object_data["clense_percent"][0]



@onready var _attack_cooldown : Timer = $AttackCoolDOwn
@onready var VFX := $VFX

var target_enemies : Array[Enemy]
var target_towers : Array[Tower]


func _ready() -> void:
	super()
	tower_placed.connect(func():
		sprite.play("idle_"+str(level))
		_attack_cooldown.autostart = true
		_attack_cooldown.start(0.5)
		#_attack_cooldown.timeout.connect(_enemy_logic)
		_attack_cooldown.timeout.connect(_support_actions)
	)

func _support_actions():
	var start_time = Time.get_ticks_usec()
	var entities := range_area.get_overlapping_areas()
	VFX.play("support_" + str(level))
	var enemy_list : Array[Enemy]
	var tower_list : Array[Tower]
	for entity in entities:
		if entity is Tower and not(entity is Flower):
			tower_list.append(entity)
		elif entity is Enemy:
			enemy_list.append(entity)
			
	_enemy_logic(enemy_list)
	_tower_logic(tower_list)
	
func _tower_logic(tower_list : Array[Tower]) -> void:
	for tower in tower_list:
		var vfx := AnimatedSprite2D.new()
		vfx.sprite_frames = load(BUFF_VFX_FPATH)
		tower.add_child(vfx)
		vfx.position += POS_OFFSET
		vfx.play("default")
		vfx.animation_finished.connect(func():
			vfx.queue_free()
		)
		for child in tower.get_children():
			if child is StatChanger:
				print("encountered the thing")
				child.update_stat_multiplier(clense_percent)
	
func _enemy_logic(enemy_list : Array[Enemy]) -> void:
	var enemies_to_effect : int = enemy_cap if enemy_list.size() >= enemy_cap else enemy_list.size()
	for i in range(enemies_to_effect):
		var money_stat = StatChanger.new()
		money_stat.initialize_variables(enemy_list[i], "flower", MONEY_MULT, buff_multiplier, buff_duration)
	
func upgrade_tower() -> void:
	super()
	sprite.play("idle_" + str(level))
	enemy_cap  = object_data["enemy_cap"][level]
	buff_multiplier = object_data["buff_multiplier"][level]
	buff_duration = object_data["buff_duration"][level]
	clense_percent = object_data["clense_percent"][level]
