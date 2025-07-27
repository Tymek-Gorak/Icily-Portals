extends Control


func _on_visibility_changed() -> void:
	if visible:
		%JoystickMovement.modulate.a = 1
		%FakeJoystick.visible = true
