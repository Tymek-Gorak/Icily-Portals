extends RayCast2D
class_name Laser


@onready var line_2d = $Line2D
@onready var animation_player = $AnimationPlayer

static var lasers_shot_counter = 0


func _ready():
	animation_player.play("fire_laser")

func _physics_process(delta):
	if is_colliding():
		var collision_point : Vector2 = get_collision_point()
		line_2d.points[1] = to_local(collision_point)

func make_sounds():
	lasers_shot_counter += 1
	if lasers_shot_counter % 4 == 0:
		AudioManager.play_audio_at_location(global_position, AudioResource.AUDIO_TYPES.FIRE_LASER)


func _on_animation_player_animation_finished(anim_name):
	queue_free()
	print(21)
