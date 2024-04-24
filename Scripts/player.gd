extends DynamicObject

@onready var ray_cast_2d = $RayCast2D
@onready var is_active = false

signal hit_level_transition
signal player_death
signal has_moved
@export var player_type : ObjectType 
@onready var sprite_2d = $Sprite2D
@onready var marker = $Marker

# Called when the node enters the scene tree for the first time.
func _ready():
	move_distance = 32
	is_movable = true
	object_type = player_type
	marker.hide()
	
	if (object_type == ObjectType.FIGHTER):
		sprite_2d.texture = load("res://Art/fighter-sprite.png")
	elif (object_type == ObjectType.ROGUE):
		sprite_2d.texture = load("res://Art/Rogue.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#check if player is controlling this paticular character\
	
	if is_active: #if true, you can move the player
		# basic tile movement
		marker.position.y = 2 * roundf(sin(Time.get_ticks_msec() * delta * 0.9)) - 20
		
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
	elif(is_level_transition(direction)):
		hit_level_transition.emit()
		queue_free()
		return
		
	#check for collisions
	var collider = get_collider(ray_cast_2d, direction, move_distance)
	
	if (collider != null):
		##collision found, determine what to do next based on what the object should do
		var object = collider.get_parent()
		ray_cast_2d.target_position = Vector2(0, 0) #ensure raycast doesn't trigger multiple times
		#Currently checks if object is moveable, check if the object in front is as well
		if (object.get_is_movable() and is_path_clear(object, direction, move_distance)):
			#will not need to check if movable once generic interaction function is implimented
			
			has_moved.emit()
			move_object(direction, move_distance)
			object.move(direction) #would replace with generic interact() once implemented
									#should be fine since I'd want the player to go onto the hazard, then die
			return
		elif (object.object_type == ObjectType.TRAP):
			has_moved.emit()
			move_object(direction, move_distance)
			#Ensure anyone other then the rogue will die if they step on the trap
			if (object_type != ObjectType.ROGUE):
				player_death.emit()
				
		elif (object.object_type == ObjectType.ENEMY):
			has_moved.emit()
			move_object(direction, move_distance)
			object.queue_free()
			
		elif (object.object_type == ObjectType.TREASURE):
			has_moved.emit()
			move_object(direction, move_distance)
			
		else:
			return
			
	#space can be walked on, move 
	has_moved.emit()
	move_object(direction, move_distance)

func _on_area_2d_area_entered(area):
	var object = area.get_parent()
	
	if (object.object_type == ObjectType.ENEMY and self.object_type != ObjectType.FIGHTER):
		player_death.emit()
