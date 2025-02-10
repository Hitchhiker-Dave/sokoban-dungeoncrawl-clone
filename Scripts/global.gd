extends Node

var music_volume = 0.0

@onready var player_turn : bool = true

func toggle_player_turn():
	player_turn = !player_turn
