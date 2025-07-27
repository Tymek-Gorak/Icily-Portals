extends Resource
class_name AudioResource
enum AUDIO_TYPES{
	CLOCK_TICKING,
	EXPLOSION,
	MAIN_MUSIC_START,
	MAIN_MUSIC_LOOP,
	MENU_MUSIC,
	FIRE_BULLET,
	FIRE_LASER,
	GAME_END,
	PORTAL_SPAWN,
	POTION_SPAWN,
	ICE_CREAM_SPAWN,
	PICK_UP_PICK_UP,
	ICE_CREAM_SELL,
	THROW,
	UPGRADE_BOUGHT,
	UPGRADE_TOO_EXPENSIVE,
	WALK,
	DMG_TAKEN,
}

@export var type : AUDIO_TYPES
@export_range(1,10,1) var limit := 5.0
@export var audio : AudioStream
@export_range(-40,20) var volume := 0.0
@export_range(0.0,4.0,.01) var pitch_scale := 1.0
@export_range(0,1.0,.01) var pitch_randomness := 0.1
@export var is_ost := false
@export var ost_loop : AUDIO_TYPES

var audio_count := 0

func change_audio_slots(change_by : int):
	audio_count = max(0, audio_count+change_by)

func  has_open_audio_slots() -> bool:
	return audio_count < limit

func on_audio_finished():
	change_audio_slots(-1)
	if is_ost:
		AudioManager.play_global_audio(ost_loop)
