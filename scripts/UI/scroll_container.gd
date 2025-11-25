extends ScrollContainer
@onready var container: ScrollContainer = $"."
@onready var h_scroll_bar: HScrollBar = $"../ScrollBarContainer/HScrollBar"


func _ready() -> void:
	var sc = container.get_h_scroll_bar()
	h_scroll_bar.max_value = sc.max_value 
	h_scroll_bar.min_value = sc.min_value
	h_scroll_bar.page = sc.page
	#print("other other max:", sc.max_value)
	#print("other other min:", sc.min_value)
	#print("other other page:", sc.page)
	
	#sc.value_changed.connect("_on_scroll_container_value_changed")

func _on_h_scroll_bar_value_changed(value: float) -> void:
	var sc = container.get_h_scroll_bar()
	container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	h_scroll_bar.max_value = sc.max_value 
	h_scroll_bar.min_value = sc.min_value
	h_scroll_bar.page = sc.page
	container.scroll_horizontal = value 
	#print("max:", h_scroll_bar.max_value)
	#print("min:", h_scroll_bar.min_value)
	#print("page:", h_scroll_bar.page)
	#print("other max:", sc.max_value)
	#print("other min:", sc.min_value)
	#print("other page:", sc.page)
	
#func _on_scroll_container_value_changed(value: float) -> void:
	#var sc = container.get_h_scroll_bar()
	#h_scroll_bar.scroll_horizontal = value 
	#sc.max_value = h_scroll_bar.max_value 
	#sc.min_value = h_scroll_bar.min_value
	#sc.page = h_scroll_bar.page
