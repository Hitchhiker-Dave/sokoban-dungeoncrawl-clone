extends DynamicObject
class_name Enemy

signal has_moved

@onready var direction = [Vector2.LEFT, Vector2.UP, Vector2.RIGHT, Vector2.DOWN]
@onready var valid_targets = [ObjectType.FIGHTER, ObjectType.ROGUE] #ROGUE Should always be last since they're stealthy

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func handle_death():
	AudioHandler.play_sfx("Hit", 0.9, 1.1)
	queue_free()

func check_if_in_melee(ray_cast_2d : RayCast2D, direction : Vector2):
	ray_cast_2d.force_raycast_update()
	var collider = get_collider(ray_cast_2d, direction, 32)
		
	if (collider != null):
		return true
	return false

#bool function that checks if there's an ally at a specific tile
func check_for_allies(ray_cast_2d : RayCast2D, direction : Vector2):
	ray_cast_2d.force_raycast_update()
	var collider = get_collider(ray_cast_2d, direction, move_distance)
	if collider:
		return get_collider(ray_cast_2d, direction, move_distance).get_parent().object_type == ObjectType.ENEMY
	return false

#function that looks for players and returns their direction as a normalized (cardinal) vector
func search_for_target(ray_cast_2d : RayCast2D):
	var player_list = []
	#looks for direction of player and returns ids
	for i in range(4):
		
		ray_cast_2d.force_raycast_update()
		var collider = get_collider(ray_cast_2d, direction[i], 9999)
		
		if (collider != null):
			var object = collider.get_parent()

			#Create lookup tuple of player's and their cardinal directions
			if ( is_player(object) and clear_shot(direction[i], object.global_position) ):
				player_list.append({"Player" : object, "Direction" : direction[i]})
	
	#check if there are any players in the list
	if (player_list.size() <= 0):
		return null #nothing found
	
	#sorts through spoted players; Fighter > Rouge, then proximity
	else:
		playerListSort(player_list)
		return player_list[0]["Direction"]

#"optimized bubble sort for quick implementation (sort list too small for notable performance hit)
func playerListSort(list : Array):
	var len : int = list.size()
	var newLen : int = -999
	while(len > 1):
		newLen = 0
		for i in range(len - 1):
			var entry1 = list[i]["Player"]
			var entry2 = list[i+1]["Player"]
			if(entry1.object_type == ObjectType.ROGUE and entry2.object_type == ObjectType.FIGHTER):
				var temp : Dictionary = list[i]
				list[i] = list[i+1]
				list[i+1] = temp
				newLen = i
		len = newLen
	return list

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
