extends Node2D

signal finised_turn

@onready var enemy_list = self.get_children()

#activate when the level says the player's turn is over (currently when the player moves)
func enemy_turn():
	if(enemy_list.size() <= 0): 
		finised_turn.emit()
		return
	
	for enemy in enemy_list:
		if is_instance_valid(enemy):
			await enemy.do_turn()
	finised_turn.emit()
