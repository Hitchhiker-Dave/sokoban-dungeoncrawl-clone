extends Node2D

@onready var next_level_menu = "res://Environments/Menus/level_select.tscn"
@onready var controls_menu = "res://Environments/Menus/controls_menu.tscn"
@onready var credits_menu = "res://Environments/Menus/credits_page.tscn"

func _ready():
	AudioHandler.play_music("Menu_Theme")

func _on_start_button_pressed():
	SceneSwitcher.switch_scene(next_level_menu)

func _on_controls_button_pressed():
	SceneSwitcher.switch_scene(controls_menu)

func _on_credits_button_pressed():
	SceneSwitcher.switch_scene(credits_menu)
