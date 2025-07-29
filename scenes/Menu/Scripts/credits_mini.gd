extends RichTextLabel



func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.is_released():
			pass
			#TODO load credits scene
