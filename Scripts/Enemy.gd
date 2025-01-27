extends DynamicObject
class_name Enemy

@onready var direction = [Vector2.LEFT, Vector2.UP, Vector2.RIGHT, Vector2.DOWN]
@onready var valid_targets = [ObjectType.FIGHTER, ObjectType.ROGUE] #ROGUE Should always be last since they're stealthy
@onready var player_list = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func check_if_in_melee(ray_cast_2d : RayCast2D, direction : Vector2):
	ray_cast_2d.force_raycast_update()
	var collider = get_collider(ray_cast_2d, direction, 32)
		
	if (collider != null):
		return true
	return false

func search_for_target(ray_cast_2d : RayCast2D):
	#looks for direction of player and returns ids
	for i in range(4):
		
		ray_cast_2d.force_raycast_update()
		var collider = get_collider(ray_cast_2d, direction[i], 9999)
		
		if (collider != null):
			var object = collider.get_parent()

			if ( is_player(object) and clear_shot(direction[i], object.global_position) ):
				player_list.append(object)
					
			else:	
				continue
	
	#sorts through spoted players and returns direction spotted
	if (player_list.size() <= 0):
		return null #nothing found
	
	else:
		var target
		for i in valid_targets:
			target = search_player_list(player_list, i)
			if (target != null):
				player_list = [] #clear list
				return target
			else:
				continue
				
	return null

func search_player_list(player_list : Array, player_type : ObjectType):
	for i in range(player_list.size()):
			if player_list[i].object_type == player_type:
				return (player_list[i].position - global_position).normalized()
	return null

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
