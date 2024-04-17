extends DynamicObject

@onready var ray_cast_2d = $RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready():
	move_distance = 32
	is_movable = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func move(direction: Vector2):
	#check if area is walkable
	if (!is_walkable(direction, move_distance)):
		return
		
	#check for collisions
	var collider = get_collider(direction, move_distance)
	
	if (collider != null):
		#collision found, determine what to do next based on what the object should do
		var object = collider.get_parent()
		
		#object is moveable, check if the object in front is as well
		if (object.get_is_movable() and is_path_clear(object, direction, move_distance)):
			object.move(direction)
		else:
			return
			
	#space can be walked on, move player
	move_object(direction, move_distance)
	
func get_collider(direction : Vector2, distance : int):
	#raycast update
	ray_cast_2d.target_position = direction * distance
	ray_cast_2d.force_raycast_update()
	
	if (ray_cast_2d.is_colliding()):
		return ray_cast_2d.get_collider()
	return null

func is_path_clear(object : DynamicObject, direction : Vector2, distance : int):
	#use recursion to see if a series of objects are pressed against a wall
	
	var new_object = object.get_collider(direction, distance)
	if (new_object == null):
		return object.is_walkable(direction, distance)
	
	return is_path_clear(new_object.get_parent(), direction, distance)
