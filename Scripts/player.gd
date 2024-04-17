extends DynamicObject

@onready var ray_cast_2d = $RayCast2D
@onready var is_active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	move_distance = 32
	is_movable = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	#check if player is controlling this paticular character\
	
	if is_active: #if true, you can move the player
		# basic tile movement
		#input buffer
		if ((Input.is_action_just_pressed("Move Up") or
			Input.is_action_pressed("Move Up"))):
			move(Vector2.UP)
		if ((Input.is_action_just_pressed("Move Down") or
			Input.is_action_pressed("Move Down"))):
			move(Vector2.DOWN)
		if ((Input.is_action_just_pressed("Move Left") or
			Input.is_action_pressed("Move Left"))):
			move(Vector2.LEFT)
		if (Input.is_action_just_pressed("Move Right") or
			Input.is_action_pressed("Move Right")):
			move(Vector2.RIGHT)

func move(direction: Vector2):
	#check if already moving
	if tween and tween.is_running():
		return
	
	#check if area is walkable
	if (!is_walkable(direction, move_distance)):
		return
		
	#check for collisions
	var collider = get_collider(ray_cast_2d, direction, move_distance)
	
	
	if (collider != null):
		##collision found, determine what to do next based on what the object should do
		var object = collider.get_parent()
		
		#object is moveable, check if the object in front is as well
		if (object.get_is_movable() and is_path_clear(object, direction, move_distance)):
			ray_cast_2d.target_position = Vector2(0, 0) #ensure raycast doesn't trigger multiple times
			move_object(direction, move_distance)
			object.move(direction)
			return
			
		else:
			return
			
	#space can be walked on, move player
	move_object(direction, move_distance)
