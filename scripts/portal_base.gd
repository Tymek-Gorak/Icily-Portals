extends Area2D
class_name PortalBase

var custom_color : Color

@export var bullet : PackedScene
@export var bullet_speed := 350
@export var icecreams_to_spawn := 3
@export var cooldown := 3
@export var cooldown_range := 1.0
@export var hp := 3
var icecreams_spawned := 0

const ICECREAM := preload("res://scenes/prefabs/icecream.tscn")
const PORTAL_CHANGED = preload("res://assets/Art/portal_changed.png")

@onready var fire_cooldown : Timer = $FireCooldown
@onready var icecream_spawn_timer = $IcecreamSpawnTimer
@onready var icey_particles = $IceyParticles
@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var animation_player = $AnimationPlayer

func _ready():
	AudioManager.play_audio_at_location(global_position, AudioResource.AUDIO_TYPES.PORTAL_SPAWN)

	fire_cooldown.wait_time = cooldown + randf_range(-cooldown_range,cooldown_range)
	custom_color = sprite_2d.self_modulate
	animation_player.play("swirl")

func shoot():
	AudioManager.play_audio_at_location(global_position, AudioResource.AUDIO_TYPES.FIRE_BULLET)


	var shot : small_bullet  = bullet.instantiate()
	var player = GameManager.player
	shot.position = position
	get_parent().add_child(shot)
	shot.look_at(player.global_position)
	shot.velocity = Vector2.RIGHT.rotated(shot.rotation) * bullet_speed


func uncorrupt():
	var tween = create_tween()
	tween.tween_property(sprite_2d, "self_modulate", Color.WHITE, 0)
	if  hp > GameManager.potion_damage:
		hp -= GameManager.potion_damage
		tween.tween_property(sprite_2d, "self_modulate", custom_color , 0.3).set_ease(Tween.EASE_OUT)
		return
	GameManager.portals_on_screen -= 1
	tween.tween_property(sprite_2d, "self_modulate", Color.SKY_BLUE, 0.3).set_ease(Tween.EASE_OUT)
	sprite_2d.texture = PORTAL_CHANGED
	icey_particles.emitting = true
	fire_cooldown.stop()
	icecream_spawn_timer.start()

func disappear():
	queue_free()


func _on_fire_cooldown_timeout():
	fire_cooldown.wait_time = randf_range(cooldown-cooldown_range, cooldown+cooldown_range)
	shoot()


func _on_icecream_spawn_timer_timeout():
	AudioManager.play_audio_at_location(global_position, AudioResource.AUDIO_TYPES.ICE_CREAM_SPAWN)
	icecreams_spawned += 1
	var icecream : PotionPickUp = ICECREAM.instantiate()
	get_parent().add_child(icecream)
	icecream.position = position
	icecream.apply_impulse(Vector2.UP.rotated(randf_range(-PI/3, PI/3)) * 150)

	if icecreams_to_spawn == icecreams_spawned:
		disappear()
