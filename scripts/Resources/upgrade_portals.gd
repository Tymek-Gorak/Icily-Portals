extends UpgradeBase
class_name UpgradePortals

@export_range(0,100) var big_portal_odds : Array[int]
@export_range(0,100) var small_portal_odds : Array[int]
@export_range(0,100) var laser_portal_odds : Array[int]
@export_range(0,10) var portal_spawn_rate : Array[float]
@export_range(0,20) var portal_cap : Array[int]

func upgrade(tier):
	GameManager.update_portal_odds(big_portal_odds[tier], small_portal_odds[tier] ,laser_portal_odds[tier] )
	GameManager.update_portal_spawn_rate(portal_spawn_rate[tier])
	GameManager.portal_cap = portal_cap[tier]
