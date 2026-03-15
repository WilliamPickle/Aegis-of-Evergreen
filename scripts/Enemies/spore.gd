extends Enemy
@onready var gas: Area2D = $Gas
@onready var gas_sprite: AnimatedSprite2D = $Gas/GasSprite
@export var effect_dur: float = 6
@export var effect_percent: float = -0.5

func _ready() -> void:
	super._ready()
	removed.connect(spawn_gas)
	gas_sprite.animation_finished.connect(func(): queue_free())
	gas.area_entered.connect(apply_debuff)
	
func spawn_gas() -> void:
	#ensure enemy was removed due to being defeated
	if cur_health > 0:
		return
	if path.progress_ratio >= 1:
		return
	
	#actual code
	gas.set_collision_mask_value(3, true)
	gas.visible = true
	gas_sprite.play("default")

func apply_debuff(tower: Tower) -> void:
	var stat_changer := StatChanger.new()
	stat_changer.initialize_variables(tower, "spore", StatChanger.Type.RANGE, effect_percent, effect_dur, true)
	tower.add_child(stat_changer)
