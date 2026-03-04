class_name Enemy
extends Area2D
signal reached_end
signal removed

# enemy stat variables
static var Game_Data = JSON.parse_string(FileAccess.get_file_as_string("res://Game Data.json"))
@export var data_resource : DataResource = DataResource.new()
@onready var object_data = Game_Data[data_resource.class_type][data_resource.object]

@onready var original_speed : float = object_data["speed"]
@onready var speed : float = original_speed
@onready var max_health : float = object_data["max_health"]
## Used to calculate damage it does against the base. 
## Formula is cur_health * base_damage_ratio
@onready var base_damage_ratio : float = object_data["base_damage_ratio"]
@onready var xp : float = object_data["xp"]
@onready var money_drop : float = object_data["money_drop"]
@onready var resistance : String = object_data["resistance"]
@onready var book_page : float = object_data["book_page"]

# enemy based variables
@export var enemy_sprite : Node2D
@export var defeat_animation : AnimatedSprite2D
@onready var enemy_node = self
## Fires when sprite is reversed
signal reversed(enemy : Enemy)
var sprite_reversed = false
# whoever has inflicted a status effect on this enemy
var status_applied_list = []
var weather_statuses : Dictionary[String, StatChanger] = {}
# keeps track what wave enemy was sent out on
var wave_number : int
var has_been_removed : bool = false

# hp bar variables
@export var hp_button: Button
## health_bar should be the child of the hp container.
## it's the green bar that contains the actual health.
@export var health_bar : Sprite2D
var cur_health : float
var bar_length : float

# path based variables
var path : PathFollow2D
var path_position = null
var cur_position = 0
var prev_position = 0
var travel_direction : int = -1

# almanac notification variables
static var enemies_seen_list : Array = []
var guidebook_popup := preload("res://scenes/UI/guidebook_popup.tscn")

func _ready() -> void:
	hp_button.button_down.connect(toggle_health_bar)
	cur_health = max_health
	bar_length = health_bar.texture.get_width() * health_bar.scale.x
	path = enemy_node.get_parent()
	enemy_node.z_index = 4
	enemy_node.set_collision_layer_value(2, true)
	enemy_node.set_collision_layer_value(1, false)
	enemy_node.set_collision_mask_value(2, true)
	enemy_node.set_collision_mask_value(1, false)
	if enemy_sprite.flip_h == true:
		sprite_reversed = true
		#enemy_sprite.flip_h = false
	#else:
		#enemy_sprite.flip_h = true
		
	# activates almanac if first time seeing enemy
	if name not in enemies_seen_list:
		enemies_seen_list.append(name)
		print("First time seeing ", name)
		show_guidebook_popup()
	
	
	
# progresses enemy along a path.
# automatically deletes enemy and path when it reaches the end
func move_on_path(delta) -> void:
	if path.progress_ratio >= 1:
		if has_been_removed:
			return
		has_been_removed = true
		emit_signal("removed")
		#print("reached end")
		if cur_health > 0:
			emit_signal("reached_end")
		path.queue_free()
		queue_free()

	path_position = path.get_global_position().x
	prev_position = cur_position
	path.progress_ratio += speed * delta
	cur_position = path_position
	
	if (cur_position - prev_position) * travel_direction < -0.1:
		travel_direction *= -1
		enemy_sprite.flip_h = !enemy_sprite.flip_h
		reversed.emit(self)

func apply_damage(damage : float, damage_type : String):
	var damage_percent = 1
	# replace 1000 with resistance
	if damage_type == resistance:
		# ADD SOME CALCULATIONS HERE WITH damage_percent
		damage_percent = object_data["resistance_percent"]
	cur_health -= damage * damage_percent
	#print("damage taken: ", damage * damage_percent)
	draw_health()

func draw_health():
	if cur_health <= 0.0:
		if has_been_removed:
			return
		has_been_removed = true
		PlayerStats.PlayerXp += xp
		PlayerStats.cur_money += money_drop
		PlayerStats.total_money_gained += money_drop
		PlayerStats.emit_signal("xp_changed")
		PlayerStats.emit_signal("money_changed")
		emit_signal("removed")
		send_away()
		await defeat_animation.animation_finished
		path.queue_free()
		queue_free()
		return
	health_bar.scale.x = cur_health / max_health
	health_bar.position.x = -(bar_length - health_bar.texture.get_width() * health_bar.scale.x) / 2
	
func toggle_health_bar():
	health_bar.get_parent().visible = !health_bar.get_parent().visible
	
func send_away() -> void:
	set_collision_layer_value(2, false)
	original_speed = 0
	speed = 0
	enemy_sprite.visible = false
	defeat_animation.visible = true
	defeat_animation.play()

func _process(delta: float) -> void:
	move_on_path(delta)

func show_guidebook_popup():
	var tree = get_tree()
	var noti_container = null
	if tree.has_group("noti_vbox"):
		for node in tree.get_nodes_in_group("noti_vbox"):
			if node.name == "GuidebookNotis":
				noti_container = node
		var notification = guidebook_popup.instantiate()
		noti_container.add_child(notification)
		notification.page_index = book_page
		#print("tried adding noti")
	else:
		#print("couldnt find noti container")
		return
	
