extends Sprite2D
class_name HeadItem

var drop_timer : SceneTreeTimer

@export var drop_curve : Curve

@onready var drop_direction := Vector2.RIGHT.rotated(randf_range(-PI, PI))

func drop():
	process_mode = Node.PROCESS_MODE_INHERIT
	drop_timer = get_tree().create_timer(.6)
	var tween = create_tween()
	tween.tween_property(self, "self_modulate", Color.TRANSPARENT, 0.3).set_ease(Tween.EASE_IN)
	await drop_timer.timeout
	queue_free()

func _physics_process(_delta):
	position.y += drop_curve.sample(drop_timer.time_left / 0.6) * 8
	position += drop_direction * 3
