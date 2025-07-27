extends UpgradeBase
class_name UpgradeFactory

const SHELL_MACHINE_TWO = preload("res://assets/Art/Shell_machine_two.png")

func upgrade(tier):
	var factory : PotionFactory = get_parent().get_parent()
	factory.level += 1
	if factory.level == 2:
		factory.texture = SHELL_MACHINE_TWO
		factory.capacity = 8
