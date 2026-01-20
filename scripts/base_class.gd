extends Area2D
## Handles the player's life, along with
## losing / replay mechanics when life = 0.
class_name Base

# life interaction variables
@export var health_label : Label
@export var base_health : float
## The minimal amount of damage any enemy will inflict
@export var damage_floor : float = 1

# needa turn off these menus upon losing so here's the variable
@export var pause_menu : UserInterface
@export var fast_forward_button : UserInterface

func _ready() -> void:
	health_label.text = str(snapped(base_health, 0.1))
	self.collision_layer = 1
	self.collision_mask = 2
	self.area_entered.connect(detect_enemy)
	
func detect_enemy(enemy: Enemy):
	enemy.reached_end.connect(take_damage.bind(enemy))
	
func take_damage(enemy: Enemy):
	var enemy_damage = roundi(enemy.cur_health * enemy.base_damage_ratio)
	
	if enemy_damage < damage_floor:
		base_health -= damage_floor
	else:
		base_health -= enemy_damage
	health_label.text = str(snapped(base_health, 0.1))
	#print("Base hp: ", base_health)
	#print("Enemy hp: ", enemy.cur_health)
	#print("*******************")
	
	if base_health <= 0:
		pause_menu.visible = false
		fast_forward_button.visible = false
		SceneLoader.load_scene("res://scenes/UI/lose_ui.tscn", "lose_ui")
		PauseUi.toggle_pause(SceneLoader._current_scenes["lose_ui"])
