@tool
extends Resource
class_name DataResource


static var GAME_DATA = JSON.parse_string(FileAccess.get_file_as_string("res://Game Data.json"))
static var _object_keys = GAME_DATA.keys()
var class_type : String = "tower":
	set(val):
		class_type = val
		notify_property_list_changed()
var object : String

var update_data : bool = false:
	set(val):
		update_data = true
		GAME_DATA = JSON.parse_string(FileAccess.get_file_as_string("res://Game Data.json"))
		_object_keys = GAME_DATA.keys()
		notify_property_list_changed()
		update_data = false


func _get_property_list() -> Array:
	var properties : Array = []
	properties.append({
		"name" : "class_type",
		"type" : TYPE_STRING,
		"usage" : PROPERTY_USAGE_DEFAULT,
		"hint" : PROPERTY_HINT_ENUM,
		"hint_string" : ",".join(_object_keys)
	})
	properties.append({
		"name" : "object",
		"type" : TYPE_STRING,
		"usage" : PROPERTY_USAGE_DEFAULT,
		"hint" : PROPERTY_HINT_ENUM,
		"hint_string" : ",".join(GAME_DATA[class_type].keys())
	})
		
	properties.append({
		"name" : "update_data",
		"type" : TYPE_BOOL,
		"usage" : PROPERTY_USAGE_DEFAULT
	})
		
#"usage" : PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_READ_ONLY
	return properties
