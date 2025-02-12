extends Node2D

signal finised_turn

@onready var enemy_list = self.get_children()
@onready var occupied_coords = []

func _ready():
	for i in range(enemy_list.size()):
		enemy_list[i].has_moved.connect(update_occupied_coords)

#activate when the level says the player's turn is over (currently when the player moves)
func enemy_turn():
	print("Enemy Turn")
	if(enemy_list.size() <= 0): 
		finised_turn.emit()
		return
	
	for enemy in enemy_list:
		if is_instance_valid(enemy):
			enemy.invalid_spaces = occupied_coords
			await enemy.do_turn()
	print("Enemy Handler- Occupided Coords", occupied_coords)
	occupied_coords = []
	finised_turn.emit()

func update_occupied_coords(position : Vector2):
	occupied_coords.append(position)
	return
