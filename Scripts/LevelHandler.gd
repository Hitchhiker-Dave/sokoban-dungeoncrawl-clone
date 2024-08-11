extends Node2D

@onready var level_select = "res://Environments/Menus/level_select.tscn"
@onready var current_level : String
@export var next_level : String
@onready var menu = $UI/Menu
@onready var ui = $UI
@onready var end_screen = $"UI/End Screen"
@onready var player_handler = $"Player Handler"
@onready var enemy_handler = $"Enemy Handler"
@onready var is_paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ui.show() #in case I forget to activate the ui after editing the level
	if player_handler: #error guard since main menu and level select don't have this
		player_handler.ready_for_next_level.connect(_end_of_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("Restart"):
		restart_level()
		
	if Input.is_action_just_pressed("ui_menu"):
		if is_paused:
			menu.hide()
			player_handler.toggle_activity()
		else:
			menu.show()
			player_handler.toggle_activity()
			
		is_paused = !is_paused
			
func restart_level():
	#genuinely no other way to automate this
	current_level = get_tree().current_scene.scene_file_path
	SceneSwitcher.switch_scene(current_level)

func go_to_next_level():
	SceneSwitcher.switch_scene(next_level)
		
func go_to_level_select():
	SceneSwitcher.switch_scene(level_select)

func _on_menu_level_select_button_pressed():
	go_to_level_select()

func _on_menu_restart_button_pressed():
	restart_level()

func _on_menu_skip_level_button_pressed():
	go_to_next_level()

func _on_player_handler_player_moved():
	player_handler.toggle_activity()
	enemy_handler.enemy_turn()
	player_handler.toggle_activity()

func _end_of_level():
	go_to_next_level()
