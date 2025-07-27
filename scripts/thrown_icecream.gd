extends ThrownPotion
class_name ThrownIcecream

const MONAY = preload("res://assets/Art/Monay.png")

@export var sell_price := 10

@onready var shadow_sprite = $ShadowSprite

func _ready():
	super._ready()
	if velocity.x < 0: potion_sprite.flip_h = true

func _on_life_time_timer_timeout():
	velocity /= 25
	drop()

func drop():
	#prevent duplicating function call
	if potion_sprite.frame == 2:
		return
	potion_sprite.frame = 2
	GameManager.icecream_wasted += 1
	disappear()

func sell():
	AudioManager.play_audio_at_location(global_position, AudioResource.AUDIO_TYPES.ICE_CREAM_SELL)

	potion_sprite.texture = MONAY
	potion_sprite.hframes = 1
	life_time_timer.paused = true
	velocity = Vector2.UP * 60
	collision_mask = 0
	GameManager.money += sell_price
	disappear()

func disappear():
	shadow_sprite.visible = false
	var tween = create_tween()
	tween.tween_property(potion_sprite, "modulate", Color.TRANSPARENT, .5)
	await get_tree().create_timer(.5).timeout
	queue_free()
