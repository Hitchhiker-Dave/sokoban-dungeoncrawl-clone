extends Node2D 
class_name DynamicObject 

enum ObjectType{
	FIGHTER,
	ROGUE,
	MAGE,
	ENVIRONMENT,
	TREASURE,
	TRAP,
	ENEMY,
	PROJECTILE
}

#Parent Class for all moveable objects (players, boulders, enemies, etc.)
#Static objects (traps, next level, treasure, anti-magic, etc.) will need its own parent class (or do I?)
var move_distance : int
var tween: Tween
var is_movable : bool
var object_type : ObjectType
@onready var tile_map = %TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func get_is_movable():
	return is_movable
	
func check_if_player(object : DynamicObject):
	return (object.object_type == ObjectType.FIGHTER or object.object_type == ObjectType.ROGUE or object.object_type == ObjectType.MAGE)
	
func is_level_transition(direction: Vector2):
	#Get current tile Vector2i
	var current_tile : Vector2i = tile_map.local_to_map(global_position)
	
	#Get target tile Vector2i
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y
	)
	#Get custom data layer from target tile
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	
	if (tile_data.get_custom_data("level_transition")):
		return true
	
	return false

func is_walkable(direction: Vector2, _distance: int):
	#Get current tile Vector2i
	var current_tile : Vector2i = tile_map.local_to_map(global_position)
	
	#Get target tile Vector2i
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y
	)
	#Get custom data layer from target tile
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	
	if (tile_data.get_custom_data("walkable")):
		return true
	
	return false

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

func get_collider(ray_cast: RayCast2D, direction : Vector2, distance : int):
	#raycast update
	ray_cast.target_position = direction * distance
	ray_cast.force_raycast_update()
	
	if (ray_cast.is_colliding()):
		return ray_cast.get_collider()
	return null

func is_path_clear(object : DynamicObject, direction : Vector2, distance : int):
	#use recursion to see if a series of objects are pressed against a wall
	
	if (!object.get_is_movable()):
		return true
	
	var new_object = object.get_collider(object.ray_cast_2d, direction, distance)
	if (new_object == null):
		return object.is_walkable(direction, distance)
	
	return is_path_clear(new_object.get_parent(), direction, distance)
	
func interaction(object : DynamicObject, direction : Vector2):
	pass
