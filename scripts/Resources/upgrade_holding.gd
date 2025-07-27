extends UpgradeBase
class_name UpgradeHolding

@export_range(3,15) var holding_levels : Array[int]

func upgrade(tier):
	GameManager.player.capacity = holding_levels[tier]
