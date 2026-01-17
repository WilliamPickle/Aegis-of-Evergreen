extends TextureRect
@onready var money_label: Label = $MoneyLabel

func _ready() -> void:
	money_label.text = "$" + str(PlayerStats.cur_money)
	PlayerStats.money_changed.connect(update_money_label)
	
func update_money_label():
	money_label.text = "$" + str(PlayerStats.cur_money)
