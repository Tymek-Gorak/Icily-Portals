extends TouchScreenButton

@export var movement_option : GameManager.CONTROL_TYPES
@export var selected_handle : SelectionHandle

func _on_released() -> void:
	GameManager.control_type = movement_option
	selected_handle.select_option(self)
