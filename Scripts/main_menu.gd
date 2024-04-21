extends Node2D

@onready var next_level = "res://Environments/Menus/level_select.tscn"

func _on_start_button_pressed():
	SceneSwitcher.switch_scene(next_level)

func _on_credits_pressed():
	pass #Credits page tba

func _on_quit_pressed():
	get_tree().quit()
