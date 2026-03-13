extends Node2D
var ran_dict : Dictionary[String, int] = {
	"Test" : 2,
}

func _ready() -> void:
	print(ran_dict)
	ran_dict.set("Test", 3)
	print(ran_dict)
	ran_dict.set("Test", 6)
	print(ran_dict)
