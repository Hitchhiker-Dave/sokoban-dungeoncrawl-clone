extends AudioStreamPlayer

func play_sfx(sfx : NodePath, min_pitch := 1.0, max_pitch := 1.0):
	var sound : AudioStreamPlayer 
	 #temp, will be global var set by settings menu in final version
	sound = get_node(sfx)
	if sound:
		
		sound.pitch_scale = randf_range(min_pitch, max_pitch)
		sound.play()

func play_music(song : NodePath):
	var music : AudioStreamPlayer 
	 #temp, will be global var set by settings menu in final version
	music = get_node(song)
	if music:
		volume_db = Global.music_volume
		
		if stream == music.stream:
			return #desired song is already playing, no need to start a new one
		
		stream = music.stream
		play()

func turn_off_music():
	stream = null
