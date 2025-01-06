extends Control

@onready var master_slider = $VBoxContainer/VBoxContainer2/Master_Slider
@onready var sfx_slider = $VBoxContainer/VBoxContainer2/SFX_Slider
@onready var music_slider = $VBoxContainer/VBoxContainer2/Music_Slider

@onready var MASTER_BUS_ID = AudioServer.get_bus_index("Master")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")

# Called when the node enters the scene tree for the first time.
func _ready():
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(MASTER_BUS_ID))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(SFX_BUS_ID))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(MUSIC_BUS_ID))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MASTER_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MASTER_BUS_ID, value < 0.05)

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_ID, value < 0.05)
	AudioHandler.play_sfx("Walk")	

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, value < 0.05)
	AudioHandler.volume_db = linear_to_db(value) #very hacky but works
	Global.music_volume = linear_to_db(value) #very hacky but works
