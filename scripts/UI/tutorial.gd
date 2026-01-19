extends Control
@onready var r_button: Button = $Background/RArrowButton
@onready var l_button: Button = $Background/LArrowButton
@onready var pages: Control = $Pages
@onready var cur_page = 1
var prev_page = 1


func _ready() -> void:
	r_button.button_up.connect(change_page.bind(r_button))
	l_button.button_up.connect(change_page.bind(l_button))
	
func change_page(button) -> void:
	if button == r_button:
		cur_page += 1
	else:
		cur_page -= 1
		
	if cur_page == 1:
		l_button.visible = false
	elif cur_page == pages.get_child_count():
		r_button.visible = false
	else:
		l_button.visible = true
		r_button.visible = true
	pages.get_child(prev_page - 1).visible = false
	pages.get_child(cur_page - 1).visible = true
	prev_page = cur_page
	
