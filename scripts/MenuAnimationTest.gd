extends Area2D

@onready var sprite_to_id = {
	$tree_front : 1,
	$tree_front2 : 1,
	$tree_mid : 2,
	$tree_mid2 : 2,
	$tree_back : 3,
	$tree_back2 : 3,
}

var sprite_speeds = {
	1 : 20,
	2 : 10,
	3 : 5,
}

var start_positions = {
	1 : Vector2(-150,0),
	2 : Vector2(-156,0),
	3 : Vector2(-157,0),
}
func _ready():
	print(sprite_to_id[$tree_front])
	
func _process(delta) -> void:
	for sprite : Sprite2D in sprite_to_id:
		var id = sprite_to_id[sprite]
		sprite.position.x += sprite_speeds[id]*delta
		if sprite.position.x >= 160 :
			sprite.position = start_positions[id]
		
