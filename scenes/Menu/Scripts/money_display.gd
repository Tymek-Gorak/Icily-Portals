extends NinePatchRect
class_name MoneyDisplay


@onready var money_count_text = $MoneyCountText

func _ready():
	GameManager.connect("money_amount_changed", update_money_display)



func update_money_display(money):
	money_count_text.text = str(money)
