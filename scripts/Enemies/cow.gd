extends Enemy

@onready var fart: Node2D = $Fart
@onready var fart_area: Area2D = $Fart/FartArea
@onready var fart_animation: AnimatedSprite2D = $Fart/FartAnimation
@onready var stat_changer: StatChanger = $StatChanger
@onready var fart_timer: Timer = $FartTimer
# none of these vars influence the timing of the other vars. 
var fart_duration: float = 1.5
var fart_cooldown: float = 5
var slowness_multiplier: float = 0.2
var slowness_duration: float = 1

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
	#if target != self:
	if target is Tower:
		print("fart mask: ", fart_area.collision_mask)
		print("mask ", target.collision_mask)
		print("layer ", target.collision_layer)
		print(target.name)
		stat_changer.apply_stat_changes(target, stat_changer.Type.ATK_COOLDOWN, slowness_multiplier, slowness_duration)
