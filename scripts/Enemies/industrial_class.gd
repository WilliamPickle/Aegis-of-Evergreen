class_name industrial_enemy
extends Enemy
@onready var duration: float = object_data["oil_duration"]
@onready var heal_amount: float = object_data["heal_amount"]
var oil := preload("res://scenes/Enemies/oil.tscn")
var new_oil

func _ready() -> void:
	super._ready()
	removed.connect(spawn_oil)

func spawn_oil() -> void:
	#ensure enemy was removed due to being defeated
	if cur_health > 0:
		return
	if path.progress_ratio >= 1:
		return
		
	new_oil = oil.instantiate()
	new_oil.visible = false
	call_deferred("add_oil_to_node")
	new_oil.global_position = global_position
	await get_tree().process_frame
	new_oil.visible = true
	print("oil heal: ", new_oil.heal_amount)

func add_oil_to_node():
	path.get_parent().add_child(new_oil)
	new_oil.duration = duration
	new_oil.heal_amount = heal_amount
