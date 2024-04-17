extends Node2D 
class_name DynamicObject 

#Parent Class for all moveable objects (players, boulders, enemies, etc.)
#Static objects (traps, next level, treasure, anti-magic, etc.) will need its own parent class
var move_distance : int
var tween: Tween
var is_movable : bool
@onready var tile_map = %TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	is_movable = true #set equivalent static_object to false if object isn't moveable

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func get_is_movable():
	return is_movable

func is_walkable(direction: Vector2, distance: int):
	#Get current tile Vector2i
	var current_tile : Vector2i = tile_map.local_to_map(global_position)
	
	#Get target tile Vector2i
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y
	)
	#Get custom data layer from target tile
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	
	if (tile_data.get_custom_data("walkable") == false):
		return false
	
	return true

func move_object(direction: Vector2, distance: int):
	#attempt to move the child to the desired direction, and return anything it collides with 
	#get desired direction
	var target_move_position = global_position + direction * distance
	
	#move object
	if tween and tween.is_running():
		return
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", target_move_position, 0.16).set_trans(Tween.TRANS_BOUNCE)
	return
