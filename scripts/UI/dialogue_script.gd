extends Control
class_name DialogueBox
signal start_wave
# This is to run the dialogue without user clicking
signal start_dialogue

# text handling variables
@export var continue_button : Button
@export var label_container : Control
@export var timer : Timer
@export var text_speed : float = 0.02
var label_list := []
var label_text : String
var cur_label_index : int = 0
var prev_label_index : int = 0

# signal handling variables
## This variable is primarily for WaveSpawner or any nodes that need
## to activate after dialogue is done. 
@export var send_wave_signal = false

# variable to hide scrollbar basically
@export var hide_node : bool = false
@export var node_to_hide : Node

@onready var wave_spawner: Node2D = $"../../WaveSpawner"

func _ready() -> void:
	# to hide the scroll bar when dialogue active
	if hide_node:
		node_to_hide.visible = false
		
	# set up dialogue list to itterate through
	for i in range(label_container.get_child_count()):
		label_list.append(label_container.get_child(i))
	continue_button.button_down.connect(display_dialogue)
	start_dialogue.connect(display_dialogue)
	emit_signal("start_dialogue")



func display_dialogue():
	# stuff to do once dialogue is done
	if cur_label_index == len(label_list):
		print("ran")
		if hide_node:
			node_to_hide.visible = true
		self.visible = false
		
		# this might be made more modular in the future but currently
		# not sure if dialogue will activate anything else
		if send_wave_signal:
			emit_signal("start_wave")
		print("last dialogue just finished.") 
		return
		
	continue_button.visible = false
	# update variables
	var current_label = label_list[cur_label_index]
	label_text = current_label.text
	
	# activate the text
	label_list[prev_label_index].visible = false
	current_label.text = ""
	current_label.visible = true
	
	# loop through each string and show them individually
	timer.wait_time = text_speed
	for letter in label_text:
		timer.start()
		await timer.timeout
		current_label.text += letter
	
	# update index
	prev_label_index = cur_label_index
	cur_label_index += 1
	
	continue_button.visible = true
