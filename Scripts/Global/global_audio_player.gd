extends AudioStreamPlayer

const MUSIC_DICTIONARY : Dictionary [String , String] = {
	"Menu" : "res://Assets/Music/NightTime.ogg" ,
	#"Menu" : "res://Assets/Music/Menu.ogg",
	"DayTime" : "res://Assets/Music/Daytime.ogg",
	"NightTime" : "res://Assets/Music/NightTime.ogg"
}


func _ready() -> void:
	set_default_sound_levels() # to 20%

func set_default_sound_levels() -> void:
	AudioServer.set_bus_volume_db(0 , linear_to_db(0.2))

func play_music(music_to_play : String, from_position : float = 0.0) -> void:
	if music_to_play not in MUSIC_DICTIONARY:
		push_error(self, " trying to play music that's not in dictionary: ", music_to_play)
		return
	
	if stream != load(MUSIC_DICTIONARY[music_to_play]):
		stream = load(MUSIC_DICTIONARY[music_to_play])
		play()

func swap_music(music_to_play : String) -> void:
	if music_to_play not in MUSIC_DICTIONARY:
		push_error(self, " trying to play music that's not in dictionary: ", music_to_play)
		return
	
	
	var current_position = get_playback_position()
	stop()
	stream = load(MUSIC_DICTIONARY[music_to_play])
	play(current_position)

func pause_music() -> void:
	stream_paused = true

func unpause_music() -> void:
	stream_paused = false

func toggle_music() -> void:
	if stream_paused:
		unpause_music()
	else:
		pause_music()

#func play_SFX(sfx_to_play : String) -> void:
	#var SFX_player = AudioStreamPlayer.new()
	#SFX_player.bus = "SFX"
	#SFX_player.stream = SFX_DICTIONARY[sfx_to_play]
	#add_child(SFX_player)
	#await SFX_player.finished
	#SFX_player.queue_free()
