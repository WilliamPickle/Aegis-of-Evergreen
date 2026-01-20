extends Enemy

var buff_duration = 4
var buff_multiplier = 1.5

func _ready():
	super._ready()
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, true)
	area_entered.connect(apply_status_effects)
	
func apply_status_effects(target):
	#print("area entered: ", target)
	if target != self:
		var stat_changer = StatChanger.new()
		stat_changer.initialize_variables(target, self.name, stat_changer.Type.WALK_SPEED, buff_multiplier, buff_duration)
		target.add_child(stat_changer)
