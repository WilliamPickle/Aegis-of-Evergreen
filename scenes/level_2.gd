extends Node2D

func _ready() -> void:
	PlayerStats.cur_money = PlayerStats.DEFAULT_MONEY[0][1]
	PlayerStats.emit_signal("money_changed")
