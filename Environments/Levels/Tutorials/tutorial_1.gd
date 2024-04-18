extends Node2D


var next_level = "res://Environments/Levels/test_level.tscn"
var level_select = "res://Environments/Menus/level_select.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	var player_handler = get_node("Player Handler")
	player_handler.reached_next_level.connect(_go_to_next_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _go_to_next_level():
	print("Signal to Start Transition to the Next Level (Current Level)")
	SceneSwitcher.switch_scene(next_level)
