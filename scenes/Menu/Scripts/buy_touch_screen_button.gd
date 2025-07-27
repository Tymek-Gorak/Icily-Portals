extends TouchScreenButton

func _ready() -> void:
	if not is_instance_valid(GameManager.player):
		push_error("Player not found")
		return
	pressed.connect(GameManager.player.interact)
