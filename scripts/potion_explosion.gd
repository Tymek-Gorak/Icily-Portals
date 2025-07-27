extends Area2D

@onready var levels = [
	[$AnimatedSprite2D, $CollisionShape2D],
	[$AnimatedSprite2D2, $CollisionShape2D2],
	[$AnimatedSprite2D3, $CollisionShape2D3]
]

func _ready():


	AudioManager.play_audio_at_location(global_position, AudioResource.AUDIO_TYPES.EXPLOSION)

	var sprite : AnimatedSprite2D = levels[GameManager.splash_zone_level][0]
	sprite.visible = true
	sprite.play("explode")
	levels[GameManager.splash_zone_level][1].disabled = false

	await get_tree().create_timer(.5).timeout
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.1)
	await tween.finished
	queue_free()

func _on_area_entered(area):
	if area is PortalBase:
		area.uncorrupt()
