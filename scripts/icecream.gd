extends PotionPickUp
class_name IcecreamPickUp

func _ready():
	animation_player.queue_free()
	animation_player = $AnimationPlayerIcecream
	super._ready()
