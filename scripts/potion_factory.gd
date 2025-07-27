extends Sprite2D
class_name PotionFactory

var force := 150
var level = 1

@export var potion : PackedScene
@export var capacity := 4

@onready var potion_container = $PotionContainer
@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("idle")

func _on_spawn_rate_timeout():
	shoot_potions()

func shoot_potions():

	if potion_container.get_child_count() < capacity:
		if level == 1:
			animation_player.play("shoot_potion")
			flip_h = not flip_h
		elif level == 2:
			animation_player.play("shoot_2_potions")
	await animation_player.animation_finished
	animation_player.play("idle")

func spawn_potion():
	AudioManager.play_audio_at_location(global_position, AudioResource.AUDIO_TYPES.POTION_SPAWN)

	var pot : PotionPickUp = potion.instantiate()
	potion_container.add_child(pot)
	if flip_h:
		pot.apply_impulse(Vector2(-1,-1).rotated(randf_range(-PI/12, PI/12)) * force)
	else:
		pot.apply_impulse(Vector2(1,-1).rotated(randf_range(-PI/12, PI/12)) * force)
