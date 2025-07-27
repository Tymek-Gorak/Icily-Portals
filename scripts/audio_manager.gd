extends Node

var audio_dictionary := {}

@export var all_audios : Array[AudioResource]

func _ready():
	for audio : AudioResource in all_audios:
		audio_dictionary[audio.type] = audio
	if all_audios.size() != audio_dictionary.size():
		push_error("cos sie nie zgadza z iloscia wczytanych dzwiekow chief")

##for removing a whole category of sound effects. used primarly for removing specific osts
func clear_audio(type : AudioResource.AUDIO_TYPES):
	if get_child_count() == 0:
		return
	for child in get_children():
		if child.max_polyphony == 500 + type:
			var audio_resource : AudioResource = audio_dictionary[type]
			#prevent ost loop on cancel
			if audio_resource.is_ost:
				audio_resource.is_ost = false
				audio_resource.on_audio_finished()
				audio_resource.is_ost = true
			else:
				audio_resource.on_audio_finished()
			child.queue_free()


func play_audio_at_location(global_location, type : AudioResource.AUDIO_TYPES):
	if audio_dictionary.has(type):
		var audio_resource : AudioResource = audio_dictionary[type]
		if audio_resource.has_open_audio_slots():
			audio_resource.change_audio_slots(1)
			var temp_audio_player := AudioStreamPlayer2D.new()
			add_child(temp_audio_player)

			temp_audio_player.position = global_location
			temp_audio_player.stream = audio_resource.audio
			temp_audio_player.volume_db = audio_resource.volume
			temp_audio_player.pitch_scale = audio_resource.pitch_scale
			temp_audio_player.pitch_scale += randf_range(-audio_resource.pitch_randomness, audio_resource.pitch_randomness)
			temp_audio_player.finished.connect(audio_resource.on_audio_finished)
			temp_audio_player.finished.connect(temp_audio_player.queue_free)
			temp_audio_player.max_polyphony = 500 + type

			temp_audio_player.play()
	else:
		push_error("matey, no such sound exists, position")

func play_global_audio(type : AudioResource.AUDIO_TYPES):
	if audio_dictionary.has(type):
		var audio_resource : AudioResource = audio_dictionary[type]
		if audio_resource.has_open_audio_slots():
			audio_resource.change_audio_slots(1)
			var temp_audio_player := AudioStreamPlayer.new()
			add_child(temp_audio_player)

			temp_audio_player.stream = audio_resource.audio
			temp_audio_player.volume_db = audio_resource.volume
			temp_audio_player.pitch_scale = audio_resource.pitch_scale
			temp_audio_player.pitch_scale += randf_range(-audio_resource.pitch_randomness, audio_resource.pitch_randomness)
			temp_audio_player.finished.connect(audio_resource.on_audio_finished)
			temp_audio_player.finished.connect(temp_audio_player.queue_free)
			temp_audio_player.max_polyphony = 500 + type

			temp_audio_player.play()
	else:
		push_error("matey, no such sound exists")
