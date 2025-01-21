extends Node2D

@onready var next_level = "res://Environments/Levels/test_level.tscn"

func _ready():
	AudioHandler.play_music("Menu_Theme")

func _on_ui_call_for_scene_change(scene):
	SceneSwitcher.switch_scene(scene)
