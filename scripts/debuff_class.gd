extends Timer
class_name Debuff
enum Type{
	NONE,
	SLOWNESS,
	BLINDNESS,
	DOUBLE_MONEY,
}
enum Target{
	ENEMY,
	TOWER,
}

func _init(type : Type, target : Target, duration : float) -> void:
	if target == Target.ENEMY:
		print("Targetting Enemy")
	else:
		print("Targetting Tower")
	wait_time = duration
	

func _ready() -> void:
	timeout.connect(func():
		queue_free()
	)
