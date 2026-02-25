extends Enemy

@onready var fart: Node2D = $Fart
@onready var fart_area: Area2D = $Fart/FartArea
@onready var fart_animation: AnimatedSprite2D = $Fart/FartAnimation
@onready var fart_timer: Timer = $FartTimer
# none of these vars influence the timing of the other vars. 
var fart_duration: float = 2 # of the animation
var fart_cooldown: float = 6
var slowness_multiplier: float = 1 # bigger num = bigger atk speed reduction
var slowness_duration: float = 3

func _ready() -> void:
	super._ready()
	fart.top_level = true
	# start fart cooldown
	fart_timer.wait_time = fart_cooldown
	fart_timer.start()
	fart_timer.timeout.connect(start_fart)
	# initialize fart collision area
	fart_area.set_collision_mask_value(3, true)
	fart_area.set_collision_mask_value(1, false)
	fart_area.area_entered.connect(apply_fart_effect)
	# set animation
	fart_animation.speed_scale = 1 / fart_duration
	fart_animation.animation_finished.connect(func():
		fart.visible = false
		fart_area.get_child(0).disabled = true
		#print("fart ended")
		)
	
func start_fart() -> void:
	#print("fart started")
	# restart the fart and fart cooldown
	fart.visible = true
	fart_area.get_child(0).disabled = false
	fart_timer.wait_time = fart_cooldown
	fart_timer.start()
	# play/position the fart animation
	fart.global_position = self.global_position
	fart_animation.play()


func apply_fart_effect(target):
	if target is Attacker:
		var stat_changer = StatChanger.new()
		stat_changer.initialize_variables(target, self.name, stat_changer.Type.ATK_COOLDOWN, 2, 50.0, true)
		target.add_child(stat_changer)
