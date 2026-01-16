extends MarginContainer

# Book setup on start: 
# Pages are shown based on layering. Make them all visible
# Since front cover always shows page one, preset tabs accordingly.

# book elements
@onready var contents: Control = $Contents
@onready var pages: Control = $Contents/Pages
@onready var right_tabs: Control = $ButtonContainer/RightTabs
@onready var left_tabs: Control = $ButtonContainer/LeftTabs
@onready var front_cover: Control = $FrontCoverMargin
@onready var back_cover: Control = $BackCoverMargin
@onready var button_container: MarginContainer = $ButtonContainer
@onready var fc_button: Button = $FrontCoverMargin/FrontCoverButton
@onready var bc_button: Button = $BackCoverMargin/BackCoverButton
@onready var left_cover: Button = $Contents/LeftCover
@onready var right_cover: Button = $Contents/RightCover
@onready var back_button: Button = $BackButtonContainer/BackButton2
var back_button_pos = [Vector2(343.0, 505.0), Vector2(620.0, 505.0)]


# the pages
var page_dict = {}

# the tab buttons
var tabs_dict = {}

# logic variables
var prev_index = 0

func _ready():
	# get pages
	for i in range(pages.get_child_count()):
		page_dict["p" + str(i)] = pages.get_child(i)
	# get tabs
	for i in range(right_tabs.get_child_count()):
		tabs_dict["r" + str(i)] = right_tabs.get_child(i)
	for i in range(left_tabs.get_child_count()):
		tabs_dict["l" + str(i)] = left_tabs.get_child(i)
		
	for i in range(floori(len(tabs_dict) / 2)):
		tabs_dict["r" + str(i)].button_down.connect(_show_page.bind(i))
		tabs_dict["l" + str(i)].button_down.connect(_show_page.bind(i))
	fc_button.button_down.connect(_show_page.bind(0))
	left_cover.button_down.connect(_show_cover.bind(front_cover))
	bc_button.button_down.connect(_show_page.bind(len(page_dict) - 1))
	right_cover.button_down.connect(_show_cover.bind(back_cover))
	
func _show_page(index):
	if !contents.visible:
		contents.visible = true
		button_container.visible = true
		front_cover.visible = false
		back_cover.visible = false
		back_button.position = back_button_pos[0]
		
	# handles tabs on left side
	for i in range(0, index + 1):
		tabs_dict["l" + str(i)].visible = true
		tabs_dict["r" + str(i)].visible = false
	# handles tabs on right side
	for i in range(index + 1, floori(len(tabs_dict) / 2)):
		tabs_dict["l" + str(i)].visible = false
		tabs_dict["r" + str(i)].visible = true
	
	# makes sure correct tab is on top of page
	page_dict["p" + str(prev_index)].z_index = 0
	tabs_dict["l" + str(prev_index)].z_index = 0
	page_dict["p" + str(index)].z_index = 1
	tabs_dict["l" + str(index)].z_index = 1
	prev_index = index
	
func _show_cover(cover):
	contents.visible = false
	button_container.visible = false
	cover.visible = true
	if cover == back_cover:
		back_button.position = back_button_pos[0]
	elif cover == front_cover:
		back_button.position = back_button_pos[1]
