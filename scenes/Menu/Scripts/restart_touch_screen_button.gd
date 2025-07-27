extends TouchScreenButton

func _ready() -> void:
	released.connect(GameManager.restart)
