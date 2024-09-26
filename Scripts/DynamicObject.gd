extends Node2D 
class_name DynamicObject #basically all the game pieces on the board

@onready var animation_speed := 0.2

enum ObjectType{
	FIGHTER,
	ROGUE,
	MAGE,
	ENVIRONMENT,
	TREASURE,
	TRAP,
	ENEMY,
	PROJECTILE,
	EXIT
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
	
func is_player(object : DynamicObject):
	return (object.object_type == ObjectType.FIGHTER or object.object_type == ObjectType.ROGUE or object.object_type == ObjectType.MAGE)
	

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
	#get desired position
	var target_move_position = global_position + direction * distance
	#move object
	if tween and tween.is_running():
		return
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", target_move_position, animation_speed).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	return
	
func move_failed(direction: Vector2, distance: int): #animation for failing to move
	var original_position = global_position
	var target_position = original_position + direction * (distance * 1/4)
	
	if tween and tween.is_running():
		return
	else:
		#move object to position before moving back to starting point
		#signal here for screen shake?
		tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", target_position, animation_speed / 2).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "global_position", original_position, animation_speed / 2).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT_IN)
	return

func get_collider(ray_cast: RayCast2D, direction : Vector2, distance : int):
	#raycast update
	ray_cast.target_position = direction * distance
	ray_cast.force_raycast_update()
	
	if (ray_cast.is_colliding()):
		return ray_cast.get_collider()
	return null

func is_path_clear(colliding_object : DynamicObject, direction : Vector2, distance : int, ignore_traps = false):
	#use recursion to see if a series of objects are pressed against a wall/immovable object
	#check if space I want to move to is empty
	if (colliding_object == null):
		return colliding_object.is_walkable(direction, distance)
	
	#check if target object is movable in the first place
	if (colliding_object.get_is_movable()):
	
		var new_object = colliding_object.get_collider(colliding_object.ray_cast_2d, direction, distance)
		if (new_object == null):
			return colliding_object.is_walkable(direction, distance)

		return is_path_clear(new_object.get_parent(), direction, distance, ignore_traps)
		
	#object not movable but is a trap
	if (colliding_object.object_type == ObjectType.TRAP and ignore_traps == true):
		return true
	
	#object is not movable
	else: 
		return false
	
func interaction(object : DynamicObject, direction : Vector2):
	pass
