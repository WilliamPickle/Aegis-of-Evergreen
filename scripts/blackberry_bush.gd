extends Enemy

# Import nodes
@onready var bush_sprite: AnimatedSprite2D = $Bush
@onready var bush: Node2D = $"."

func _ready() -> void:
	# Initialize Enemy class variables
	enemy_sprite = bush_sprite
	path = bush.get_parent()
	print("script ran")
	
func _process(delta) -> void:
	move_on_path(delta)
