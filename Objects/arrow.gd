extends DynamicObject
#will be the only thing to break the rules of the game by not moving in a grid

var facing : Vector2
@onready var ray_cast_2d = $RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready():
	object_type = ObjectType.ENEMY
	move_distance = 1
	rotation = rotation
	look_at(facing)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#to do: make sprite face direction (polar to cartesion coord conversion might do it)
	if (not is_walkable(facing, move_distance)):
		#collided with wall
		queue_free()
		return
		
	var collider = get_collider(ray_cast_2d, facing, move_distance)
	
	if (collider != null):
		var object = collider.get_parent()
		
		if (check_if_player(object)):
			#player collision handling
			if (object.object_type != ObjectType.FIGHTER):
				object.queue_free()
				queue_free()
			else:
				queue_free()
			
		elif (object.object_type == ObjectType.ENVIRONMENT):
			queue_free()
			
	position += facing * move_distance
