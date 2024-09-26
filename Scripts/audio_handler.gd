extends AudioStreamPlayer

func play_sfx(sfx : NodePath, min_pitch := 1.0, max_pitch := 1.0):
	var sound : AudioStreamPlayer 
	var sfx_volume = 0.0 #temp, will be global var set by settings menu in final version
	sound = get_node(sfx)
	if sound:
		
		sound.pitch_scale = randf_range(min_pitch, max_pitch)
		sound.volume_db = sfx_volume
		sound.play()

func play_music(song : NodePath):
	var music : AudioStreamPlayer 
	var music_volume = 0.0 #temp, will be global var set by settings menu in final version
	music = get_node(song)
	if music:
		if stream == music.stream:
			return #desired song is already playing, no need to start a new one
		
		stream = music.stream
		volume_db = music_volume
		play()

func toggle_music():
	if stream:
		stream_paused = true
	else:
		stream_paused = false
