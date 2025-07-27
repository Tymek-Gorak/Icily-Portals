extends Control
class_name PauseMenu


const MENU = "res://scenes/Menu/menu.tscn"

@onready var camera : Camera2D = get_viewport().get_camera_2d()
@onready var menu: PanelContainer = %Menu
@onready var pause_button: PauseButton = %PauseButton

func _ready() -> void:
	menu.visible = false
	if not is_instance_valid(camera):
		push_error("main camera doesnt exist")

	#updating the mute button's appearance based on whether the audio is on or not
	if AudioServer.is_bus_mute(0):
		var button_atlas : AtlasTexture = %AudioTouchButton.texture_normal
		button_atlas.region.position.x = 0
	else:
		var button_atlas : AtlasTexture = %AudioTouchButton.texture_normal
		button_atlas.region.position.x = 116



func _input(event: InputEvent) -> void:
	if GameManager.game_ended:
		return

	if event.is_action_pressed("pause") and not get_tree().paused:
		pause()
	elif event.is_action_pressed("pause") and get_tree().paused:
		resume()

func pause():
	if get_tree().paused == true:
		return
	get_tree().paused = true
	pause_button.on_pause()
	pause_button
	menu.visible = true
	AudioManager.clear_audio(AudioResource.AUDIO_TYPES.CLOCK_TICKING)
	AudioServer.set_bus_effect_enabled(0,0,true)
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(camera, ^"zoom", Vector2.ONE * .86, 0.4)


func resume():
	if get_tree().paused == false:
		return
	get_tree().paused = false
	pause_button.on_resume()
	menu.visible = false
	if GameManager.game_started:
		AudioManager.play_global_audio(AudioResource.AUDIO_TYPES.CLOCK_TICKING)
	AudioServer.set_bus_effect_enabled(0,0,false)
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(camera, ^"zoom", Vector2.ONE, 0.4)


func _on_audio_touch_button_released() -> void:
	if not AudioServer.is_bus_mute(0):
		AudioServer.set_bus_mute(0, true)
		var button_atlas : AtlasTexture = %AudioTouchButton.texture_normal
		button_atlas.region.position.x = 0
	else:
		AudioServer.set_bus_mute(0, false)
		var button_atlas : AtlasTexture = %AudioTouchButton.texture_normal
		button_atlas.region.position.x = 116


func _on_menu_touch_button_released() -> void:
	AudioServer.set_bus_effect_enabled(0,0,false)
	get_tree().paused = false
	get_tree().change_scene_to_file.call_deferred(MENU)
