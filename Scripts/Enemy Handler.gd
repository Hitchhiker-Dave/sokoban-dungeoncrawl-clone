extends Node2D

@onready var enemy_list = self.get_children()

#activate when the level says the player's turn is over (currently when the player moves)
func enemy_turn():
	for enemy in enemy_list:
		enemy.do_turn()
