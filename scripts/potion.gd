extends RigidBody2D
class_name PotionPickUp

@export var spawn_height_curve : Curve
@export var drop_height := 50

@onready var drop_timer = $DropTimer
@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer

var spent := false

func _ready():
	animation_player.play("air_spin")

func _physics_process(_delta):
	sprite_2d.position.y = spawn_height_curve.sample((drop_timer.wait_time - drop_timer.time_left) / drop_timer.wait_time) * -drop_height
	if drop_timer.time_left < 0.1 and drop_timer.is_stopped() == false:
		animation_player.play("spawn_in")
