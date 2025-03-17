extends Node2D

@onready var credits = "res://Environments/Menus/credits_page.tscn"
# Called when the node enters the scene tree for the first time.
func _ready():
	AudioHandler.play_music("Menu_Theme")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed():
	SceneSwitcher.switch_scene(credits)
