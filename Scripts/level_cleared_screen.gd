extends Control

signal trigger_level_select
signal trigger_level_restart
signal trigger_next_level

@onready var pc_alive_display = $"VBoxContainer/HBoxContainer2/Adventurers Count"
@onready var treasure_found_display = $"VBoxContainer/HBoxContainer3/Treasure Count"

var surviving_players : int 
var total_players : int

var treasure_gained : int
var total_treasure : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): #most likely where the "animation" for the UI will go
	pass


func _on_level_select_button_pressed():
	trigger_level_select.emit()

func _on_restart_button_pressed():
	trigger_level_restart.emit()

func _on_next_level_button_pressed():
	trigger_next_level.emit()

func update_player_score(survivors : int, total : int):
	surviving_players = survivors
	total_players = total

func update_treasure_score(loot : int, total : int):
	treasure_gained = loot
	total_treasure = total

func update_display():
	pc_alive_display.set_text(str(surviving_players) + " / " + str(total_players))
	treasure_found_display.set_text(str(treasure_gained) + " / " + str(total_treasure))
