extends TouchScreenButton
class_name JoystickMovement

@export var is_one_handed := false
var movement_direction : Vector2
@onready var joystick_pip: Sprite2D = %MovementPip
@onready var joystick_dimensions = Vector2(texture_normal.get_width(), texture_normal.get_height())
@onready var starting_position := global_position



func _init() -> void:
	GameManager.joystick_movement = self

func _input(event: InputEvent) -> void:
	if event is not InputEventScreenDrag and event is not InputEventScreenTouch:
		return
	if not is_one_handed:
		var event_on_right_side : bool = event.position.x > get_viewport_rect().size.x/2
		if (event_on_right_side and GameManager.is_right_handed or not event_on_right_side and not GameManager.is_right_handed) and not is_pressed():
			return
	if is_one_handed:
		modulate.a = 1

	if event is InputEventScreenTouch and not is_pressed():
		position = event.position - scale * joystick_dimensions/2
		await get_tree().create_timer(.11).timeout
		if not is_pressed():
			_on_released()


	if event is InputEventScreenDrag and is_pressed():
		var joystick_center = joystick_dimensions/2
		var direction_to_touch : Vector2 = event.position - to_global(joystick_center)
		joystick_pip.position = joystick_center + direction_to_touch.normalized() * clamp(direction_to_touch.length(), 0, joystick_dimensions.x/2)
		#lerp to touch when its too far
		movement_direction = (joystick_pip.position - joystick_center) / (joystick_dimensions.x/2)
		while direction_to_touch.length() > joystick_dimensions.x/1.4:
			position = position.move_toward(event.position - scale * joystick_dimensions/2, 2)
			direction_to_touch = event.position - to_global(joystick_center)

func _on_released() -> void:
	joystick_pip.position = joystick_dimensions/2
	movement_direction = Vector2.ZERO
	position = starting_position
	if is_one_handed:
		modulate.a = 0

func _on_visibility_changed() -> void:
	if visible:
		GameManager.joystick_movement = self
