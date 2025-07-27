extends TouchScreenButton
class_name PauseButton

@export var distance := 200
@export var offscreen_direction : Vector2:
	set(new):
		offscreen_direction = new.normalized()

@onready var starting_position = position

func on_pause():
	position = starting_position
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(self, ^"position", position - offscreen_direction * distance * 0.15, .1)
	tween.tween_property(self, ^"position", position + offscreen_direction * distance, .15).set_ease(Tween.EASE_IN)

func on_resume():
	position = starting_position + offscreen_direction * distance
	var tween = create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(self, ^"position", position - offscreen_direction * distance, .25)
