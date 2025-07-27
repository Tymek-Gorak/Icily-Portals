extends CharacterBody2D
class_name small_bullet

@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	animated_sprite_2d.play("default")

func _physics_process(delta):
	move_and_slide()
	if get_slide_collision_count() > 0:
		queue_free()
