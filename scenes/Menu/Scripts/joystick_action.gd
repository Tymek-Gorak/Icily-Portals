extends TouchScreenButton
class_name JoystickAction

var aim_direction : Vector2
@onready var joystick_dimensions = Vector2(texture_normal.get_width(), texture_normal.get_height())
@onready var joystick_pip: Sprite2D = %ActionPip
@onready var starting_position := global_position

func _init() -> void:
	GameManager.joystick_action = self

func _input(event: InputEvent) -> void:

	if event is not InputEventScreenDrag and event is not InputEventScreenTouch:
		return
	var event_on_left_side : bool = event.position.x < get_viewport_rect().size.x/2
	if (event_on_left_side and GameManager.is_right_handed or not event_on_left_side and not GameManager.is_right_handed) and not is_pressed():
		return

	if event is InputEventScreenTouch and not is_pressed():
		position = event.position - scale * joystick_dimensions/2
		await get_tree().create_timer(.001).timeout
		if not is_pressed():
			_on_released()

	if event is InputEventScreenDrag and is_pressed():
		var joystick_center = joystick_dimensions/2.0
		var direction_to_touch : Vector2 = event.position - to_global(joystick_center)
		joystick_pip.position = joystick_center + direction_to_touch.normalized() * clamp(direction_to_touch.length(), 0, joystick_dimensions.x/2)
		aim_direction = (joystick_pip.position - joystick_center) / (joystick_dimensions.x/2)


func _on_released() -> void:
	joystick_pip.position = joystick_dimensions/2
	aim_direction = Vector2.ZERO
	position = starting_position


func _on_visibility_changed() -> void:
	if visible:
		GameManager.joystick_action = self
