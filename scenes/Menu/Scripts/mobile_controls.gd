extends Control

@onready var movement_modes : Array[Control] = [%TwoHandedRighty, %TwoHandedLefty, %OneHanded]

func _ready() -> void:
	if GameManager.is_touch_screen_device:
		visible = true
	GameManager.connect("controls_changed", change_controls)

	#TODO changing controls based off settings. might have to move this line over to game manager
	GameManager.control_type = GameManager.CONTROL_TYPES.TWO_HANDED_RIGHTY



func change_controls(controls_type : GameManager.CONTROL_TYPES ):
	for mode in movement_modes:
		mode.visible = false

	match controls_type:
		GameManager.CONTROL_TYPES.ONE_HANDED:
			%OneHanded.visible = true
		GameManager.CONTROL_TYPES.TWO_HANDED_RIGHTY:
			%TwoHandedRighty.visible = true
			GameManager.is_right_handed = true
		GameManager.CONTROL_TYPES.TWO_HANDED_LEFTY:
			%TwoHandedLefty.visible = true
			GameManager.is_right_handed = false
