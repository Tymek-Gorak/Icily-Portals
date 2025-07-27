extends Sprite2D
class_name SelectionHandle

func select_option(option : Node2D):
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(self, ^"position", option.position, .3)
