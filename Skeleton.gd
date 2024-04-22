extends DynamicObject

#Similar to player, will need a enemy handler to determine when an enemy is allowed to act
@onready var arrow = preload("res://Objects/arrow.tscn")
@onready var ray_cast_2d = $RayCast2D
@onready var direction = [Vector2.LEFT, Vector2.UP, Vector2.RIGHT, Vector2.DOWN]

# Called when the node enters the scene tree for the first time.
func _ready():
	object_type = ObjectType.ENEMY

#do turn when enemy handler says so
func do_turn():
	var target_direction = search_for_target()
	if(target_direction):
		var instance = arrow.instantiate()
		instance.facing = target_direction
		add_sibling(instance)
		instance.position = global_position
		instance.tile_map = tile_map

func search_for_target():
	#looks for direction of player and returns direction
	for i in range(4):
		ray_cast_2d.force_raycast_update()
		var collider = get_collider(ray_cast_2d, direction[i], 9999)
		
		if (collider != null):
			var object = collider.get_parent()
			print(object)

			if check_if_player(object):
				#walk to see if reachable; whole thing is glitchy but works
				if not clear_shot(direction[i], object.global_position):
					continue
				
				if object.object_type == ObjectType.FIGHTER:
					return direction[i]
				elif object.object_type == ObjectType.ROGUE:
					return direction[i]
					
			else:
				continue
				
	return null #nothing found

func clear_shot(direction : Vector2, end_position : Vector2):
	#Get current tile Vector2i
	var current_tile : Vector2i = tile_map.local_to_map(global_position)
	var end_tile : Vector2i = tile_map.local_to_map(end_position)
	while true:
		#Get target tile Vector2i
		var target_tile: Vector2i = Vector2i(
			current_tile.x + direction.x,
			current_tile.y + direction.y
		)
		if target_tile == end_tile:
			return true
		
		#Get custom data layer from target tile
		var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
		
		if (tile_data.get_custom_data("walkable")):
			current_tile = target_tile
		else:
			return false
