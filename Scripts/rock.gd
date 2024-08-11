extends DynamicObject

@onready var ray_cast_2d = $RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready():
	move_distance = 32
	is_movable = true
	object_type = ObjectType.ENVIRONMENT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func move(direction: Vector2):
	#check if already moving
	if tween and tween.is_running():
		return
	
	#check if area is walkable
	if (!is_walkable(direction, move_distance)):
		move_failed(direction, move_distance)
		return
		
	#check for collisions
	var collider = get_collider(ray_cast_2d, direction, move_distance)
	
	if (collider != null):
		#collision found, determine what to do next based on what the object should do
		var object = collider.get_parent()
		ray_cast_2d.target_position = Vector2(0, 0) #ensure raycast doesn't trigger multiple times
		
		#disarm trap; do not remove, player clips into pushed rock otherwise
		if (object.object_type == ObjectType.TRAP):
			#disarm trap sound
			move_object(direction, move_distance) #trap automatically despawns if anything enters it's hitbox
			return
		
		#object is moveable, check if the object in front is as well
		if (object.get_is_movable()):
			if (is_path_clear(object, direction, move_distance, true)):
				move_object(direction, move_distance)
				object.move(direction)
				return
			
			else:
				object.move_failed(direction, object.move_distance)
				return
			return
	#space can be walked on, move player
	#custom sound effect for rock moving here
	move_object(direction, move_distance)
	

