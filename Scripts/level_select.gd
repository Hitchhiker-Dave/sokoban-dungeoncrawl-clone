extends Node2D

@onready var next_level = "res://Environments/Levels/test_level.tscn"

func _on_start_menu_pressed():
	SceneSwitcher.switch_scene("res://Environments/Menus/main_menu.tscn")

func _on_test_level_pressed():
	SceneSwitcher.switch_scene("res://Environments/Levels/test_level.tscn")

func _on_tutorial_1_pressed():
	SceneSwitcher.switch_scene("res://Environments/Levels/Tutorials/level1.tscn")

func _on_template_level_pressed():
	SceneSwitcher.switch_scene("res://Environments/Levels/level_template.tscn")
