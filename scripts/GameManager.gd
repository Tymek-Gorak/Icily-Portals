extends Node

signal money_amount_changed(new_amount)
signal start_game()
signal end_game()
signal new_high_score()
signal update_portal_odds_signal(new_big_odds, new_small_odds, new_laser_odds)
signal update_portal_spawn_rate_signal(new_spawn_rate)
signal spawn_portal_signal()
signal controls_changed(new_controls : CONTROL_TYPES)

enum PORTAL_TYPES {BIGSHOT, SMALLSHOT, LASER}
enum CONTROL_TYPES {ONE_HANDED, TWO_HANDED_RIGHTY, TWO_HANDED_LEFTY, NONE}


#options
var is_right_handed := true
var control_type : CONTROL_TYPES:
	set(new_controls):
		controls_changed.emit(new_controls)
		control_type = new_controls
#object references
var player : Cutlet
var joystick_movement : JoystickMovement
var joystick_action : JoystickAction
#upgradables
var potion_damage := 1
var splash_zone_level := 0
var portal_cap := 5
#operation-system-required
var portals_on_screen := 1
var game_started := false
var game_ended := false
var time_remaining := 7 * 60
var money_made := 0
var money := 0:
	set(new_money):
		if new_money > money:
			money_made += new_money - money
		money = new_money
		money_amount_changed.emit(new_money)

var high_score := 0
var icecream_wasted := 0
var dmg_taken := 0


@onready var is_touch_screen_device : bool = OS.has_feature("web_android") or OS.has_feature("web_ios") or OS.has_feature("mobile")
#@onready var is_touch_screen_device : bool = true


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	money_amount_changed.emit(money)


func start():
	AudioManager.play_global_audio(AudioResource.AUDIO_TYPES.CLOCK_TICKING)
	AudioManager.play_global_audio(AudioResource.AUDIO_TYPES.MAIN_MUSIC_START)
	AudioManager.clear_audio(AudioResource.AUDIO_TYPES.MENU_MUSIC)
	AudioManager.clear_audio(AudioResource.AUDIO_TYPES.GAME_END)

	game_started = true
	start_game.emit()
	spawn_portal()
	dmg_taken = 0

func end():
	AudioManager.clear_audio(AudioResource.AUDIO_TYPES.CLOCK_TICKING)
	AudioManager.clear_audio(AudioResource.AUDIO_TYPES.MAIN_MUSIC_START)
	AudioManager.clear_audio(AudioResource.AUDIO_TYPES.MAIN_MUSIC_LOOP)
	AudioManager.play_global_audio(AudioResource.AUDIO_TYPES.MENU_MUSIC)
	AudioManager.play_global_audio(AudioResource.AUDIO_TYPES.GAME_END)

	if money > high_score:
		high_score = money
		new_high_score.emit()
	end_game.emit()
	await get_tree().create_timer(.2).timeout
	game_ended = true
	get_tree().paused = true

func spawn_portal():
	spawn_portal_signal.emit()

func update_portal_odds(big_odds, small_odds, laser_odds):
	update_portal_odds_signal.emit(big_odds, small_odds, laser_odds)

func update_portal_spawn_rate(spawn_rate):
	update_portal_spawn_rate_signal.emit(spawn_rate)

func restart():
	AudioManager.clear_audio(AudioResource.AUDIO_TYPES.GAME_END)
	AudioManager.clear_audio(AudioResource.AUDIO_TYPES.CLOCK_TICKING)
	AudioManager.clear_audio(AudioResource.AUDIO_TYPES.MAIN_MUSIC_LOOP)
	AudioManager.clear_audio(AudioResource.AUDIO_TYPES.MAIN_MUSIC_START)
	AudioManager.play_global_audio(AudioResource.AUDIO_TYPES.MENU_MUSIC)

	portals_on_screen = 0
	money = 0
	potion_damage = 1
	splash_zone_level = 0
	time_remaining = 7*60
	money_made = 0
	icecream_wasted = 0
	game_started = false
	game_ended = false
	get_tree().paused = false
	get_tree().change_scene_to_file.call_deferred("res://scenes/icecream_shop.tscn")

func _input(event):
	if event.is_action_pressed("restart"):
		restart()
