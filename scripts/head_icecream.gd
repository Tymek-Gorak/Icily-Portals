extends HeadItem
class_name HeadIcecream

func drop():
	GameManager.icecream_wasted += 1
	super.drop()
