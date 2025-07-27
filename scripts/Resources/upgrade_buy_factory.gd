extends UpgradeBase
class_name BuyFactory

var factory_scene :PackedScene = preload("res://scenes/prefabs/potion_factory.tscn")

func upgrade(tier):
	if GameManager.game_started == false : GameManager.start()
	var factory : PotionFactory = factory_scene.instantiate()
	get_parent().get_parent().add_child(factory)
	factory.position = get_parent().position
	factory.position.y -= 35
