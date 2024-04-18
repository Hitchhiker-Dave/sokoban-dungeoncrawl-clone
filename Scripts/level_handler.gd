extends Node2D


var next_level = "res://Environments/Levels/test_level.tscn"
var level_select = "res://Environments/Menus/level_select.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_level_select_button_pressed():
	SceneSwitcher.switch_scene(level_select)

func _on_player_handler_ready_for_next_level():
	SceneSwitcher.switch_scene(next_level)
