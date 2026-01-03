extends Area2D

const COLOR = Color(0.75,0,0,0.3)

var attack_shape : CollisionPolygon2D
var tower : Tower
var can_draw := false


#func _draw() -> void:
	#if Tower.current_tower == tower:
		##draw_arc(Vector2.ZERO, 100, (attack_shape.polygon[4]).angle(), (attack_shape.polygon[2]).angle(), 25, COLOR, 2)
		#draw_polygon(attack_shape.polygon, [COLOR])
		
