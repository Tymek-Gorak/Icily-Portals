extends CharacterBody2D
class_name ThrownPotion

@export var speed = 350
var throw_direction : Vector2

@export var height_curve : Curve
@export var potion_explosion : PackedScene

@onready var potion_sprite : Sprite2D  = $PotionSprite
@onready var life_time_timer : Timer = $LifeTimeTimer


func _ready():
	velocity = throw_direction.normalized() * speed

func _physics_process(delta):
	potion_sprite.position.y = height_curve.sample(life_time_timer.wait_time - life_time_timer.time_left)
	move_and_slide()
	if get_slide_collision_count():
		_on_life_time_timer_timeout()


func _on_life_time_timer_timeout():
	var explosion : Area2D  = potion_explosion.instantiate()
	explosion.position = position
	get_parent().add_child(explosion)
	queue_free()
