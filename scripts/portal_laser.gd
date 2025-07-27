extends PortalBase
class_name LaserPortal

func shoot():
	var shot : LaserCross  = bullet.instantiate()
	shot.position = position
	get_parent().add_child(shot)
