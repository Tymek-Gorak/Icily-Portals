extends Button

const ICECREAM_SHOP = "res://scenes/icecream_shop.tscn"

func _ready() -> void:
	AudioManager.play_global_audio(AudioResource.AUDIO_TYPES.MENU_MUSIC)

func _on_button_up():
	get_tree().change_scene_to_file.call_deferred(ICECREAM_SHOP)
