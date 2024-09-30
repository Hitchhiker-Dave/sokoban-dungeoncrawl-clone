extends Node2D

@onready var level_select = "res://Environments/Menus/level_select.tscn"
@onready var current_level : String
@export var next_level : String
@onready var menu := $UI/Menu
@onready var ui := $UI
@onready var end_screen := $"UI/End Screen"
@onready var player_handler := $"Player Handler"
@onready var enemy_handler := $"Enemy Handler"
@onready var is_paused := false
@onready var level_cleared_screen := $UI/level_cleared_screen
@onready var is_level_cleared := false
@onready var treasure_handler = $"Treasure Handler"

#end of level handling for pc scoring
var pcs_alive : int
var total_pcs : int

#end of level handling for treasure scoring
var treasure_looted : int
var total_treasure : int

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioHandler.turn_off_music() #temp until main game music is made
	ui.show() #in case I forget to activate the ui after editing the level
	
	treasure_looted = 0
	total_treasure = treasure_handler.get_total_treasure()
	treasure_handler.treasure_looted.connect(update_treasure_looted)
	
	pcs_alive = 0
	total_pcs = player_handler.get_player_count()
	player_handler.level_exited.connect(update_players_exited_level)
	player_handler.ready_for_next_level.connect(_end_of_level)
		
	level_cleared_screen.trigger_level_select.connect(go_to_level_select)
	level_cleared_screen.trigger_level_restart.connect(_on_menu_restart_button_pressed)
	level_cleared_screen.trigger_next_level.connect(go_to_next_level)
	
	#manual update to guarentee the max score counts are displayed
	level_cleared_screen.update_player_score(pcs_alive, total_pcs)
	level_cleared_screen.update_treasure_score(treasure_looted, total_treasure)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("Restart"):
		restart_level()
		
	#Pause Menu Handling; Does not activate if dealing with end of level menus
	if Input.is_action_just_pressed("ui_menu") and !is_level_cleared:
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
	
func update_players_exited_level():
	pcs_alive += 1
	level_cleared_screen.update_player_score(pcs_alive, total_pcs)
	
func update_treasure_looted():
	treasure_looted += 1
	level_cleared_screen.update_treasure_score(treasure_looted, total_treasure)
	
func _end_of_level():
	#no need to disable player movement, all players should be dead or dealt with
	is_level_cleared = true
	level_cleared_screen.update_display()
	level_cleared_screen.show()
