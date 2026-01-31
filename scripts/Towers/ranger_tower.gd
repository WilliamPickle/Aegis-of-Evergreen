extends Tower
class_name Ranger
# READ HERE
# The tower will detect other towers at a set amount of time set in DetectionSpeed node
const stat_type := StatChanger.Type
@onready var _detection_speed : Timer = $DetectionSpeed
@onready var buff_types : Array = object_data["buff_types"][0]
@onready var buff_multipliers : Array = object_data["buff_multipliers"][0]
@onready var buff_duration : float = object_data["buff_duration"]

static var does_exist := false

func _ready() -> void:
	#if does_exist:
		#queue_free()
		#return
	super._ready()
	tower_placed.connect(func():
		#if does_exist:
			#queue_free()
			#var notif = Error_Notification.new()
			#map_area.add_child(notif)
			#notif.send_notif(global_position,"max of 1 ranger")
			#return
		does_exist = true
		_detection_speed.autostart = true
		_detection_speed.start()
		_detection_speed.timeout.connect(detect_tower)
		)

func place_tower() -> bool:
	if get_overlapping_areas().size() > 0:
		var notif := Error_Notification.new()
		map_area.add_child(notif)
		notif.send_notif(global_position,"can't place here")
		return false

	if does_exist:
		queue_free()
		Tower_Placement.reset_data()
		var notif = Error_Notification.new()
		map_area.add_child(notif)
		notif.send_notif(global_position,"max of 1 ranger")
		return false

	if !PlayerStats.purchase_item(cost):
		queue_free()
		Tower_Placement.reset_data()
		var notif := Error_Notification.new()
		map_area.add_child(notif)
		notif.send_notif(global_position,"not enough funds")
		return true
	
	disable_placement()
	
	return true


func detect_tower():
	sprite.play("attacking")
	var tower_list = range_area.get_overlapping_areas()
	#for buff : String in buff_types:
	for tower in tower_list:
		if tower is Attacker:
			print("ran with tower:",tower)
			for i in range(buff_types.size()):
				var stat
				if buff_types[i] == "range":
					stat = stat_type.RANGE
				else:
					stat = stat_type.ATK_COOLDOWN
					
				var stat_changer := StatChanger.new()
				stat_changer.initialize_variables(tower, name + buff_types[i], stat, buff_multipliers[i], buff_duration)
				tower.add_child(stat_changer)

	await sprite.animation_finished
	sprite.play("idle")

#func place_tower() -> bool:
	#return false

func upgrade_tower() -> void:
	super.upgrade_tower()
	buff_types = object_data["buff_types"][level]
	buff_multipliers = object_data["buff_multipliers"][level]
