extends DynamicObject
class_name Player

@onready var ray_cast_2d = $RayCast2D
@onready var is_active = false

#custom signals
signal hit_level_transition
signal player_death
signal has_moved

@onready var marker = $Marker

# Called when the node enters the scene tree for the first time.
func _ready():
	move_distance = 32
	is_movable = true
	
	return

#stop player from inheriting movement when changing levels or when a pc dies while moving 
func stop_ghost_movement():
	move_object(Vector2.ZERO, move_distance) #hacky way of stoping someone from moving
	#note: if the player is still holding down the button when they enter a new
	#level or while a pc dies, then the movement still caries over (tbh it kinda
	#leans into the OSR idea that dungeons are dangerous and pcs can't be reckless)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	#check if player is controlling this paticular character
	if !is_active: #early return if you can't move the player
		return
	
	# basic tile movement
	marker.position.y = 2 * roundf(sin(Time.get_ticks_msec() * delta * 0.9)) - 24
	
	if (Input.is_action_just_pressed("Wait")):
		post_player_move() #basically forfiet a turn
	if (Input.is_action_just_pressed("Move Up")):
		move(Vector2.UP)
		post_player_move()
	if (Input.is_action_just_pressed("Move Down")):
		move(Vector2.DOWN)
		post_player_move()
	if (Input.is_action_just_pressed("Move Left")):
		move(Vector2.LEFT)
		post_player_move()
	if (Input.is_action_just_pressed("Move Right")):
		move(Vector2.RIGHT)
		post_player_move()

#generic function for pushing an object; i.e. allows fighter to push rocks, but not rogue and wizard
func push_object(object: DynamicObject, direction : Vector2, move_distance : int):
	AudioHandler.play_sfx("Walk", 0.9, 1.1)
	move_object(direction, move_distance)
	AudioHandler.play_sfx("Push", 0.9, 1.1)
	object.move(direction)
	return

func move(direction: Vector2):
	#check if already moving
	if tween and tween.is_running():
		return
	
	#check if area is walkable
	if (!is_walkable(direction, move_distance)):
		#play_sound(cant_move, 0.9, 1.1)
		AudioHandler.play_sfx("Cant_Move", 0.9, 1.1)
		move_failed(direction, move_distance)
		return
		
	#check for collisions
	var collider = get_collider(ray_cast_2d, direction, move_distance)
	
	if (collider != null):
		##collision found, determine what to do next based on what the object should do
		var object = collider.get_parent()
		ray_cast_2d.target_position = Vector2(0, 0) #ensure raycast doesn't trigger multiple times
		
		#check if player object is about to leave level
		if (object.object_type == ObjectType.EXIT):
			move_object(direction, move_distance)
			AudioHandler.play_sfx("Level_End", 1.0, 1.2)
			handle_level_transistion()
			return
		
		elif (object.get_is_movable()):
			if is_path_clear(object, direction, move_distance, true):
				push_object(object, direction, move_distance)
				return
			else: 
				AudioHandler.play_sfx("Cant_Move", 0.9, 1.1)
				move_failed(direction, move_distance)
				return
		
		#Universal Object Interactions (I.e. same for all class/player types)	
		elif (object.object_type == ObjectType.TREASURE):
				AudioHandler.play_sfx("Walk", 0.9, 1.1)
				move_object(direction, move_distance)
				return
		
		#Specific Object interactions based on class/player type
		else:
			object_collision(object, direction, move_distance)
			return
	
	else:	
		#space can be walked on, move 
		AudioHandler.play_sfx("Walk", 0.9, 1.1)
		self.move_object(direction, move_distance)
		return
	
func handle_death():
	AudioHandler.play_sfx("Hit", 0.9, 1.1)
	player_death.emit()
	queue_free()

func handle_level_transistion():
	hit_level_transition.emit() #move to level exit
	queue_free()
	
func post_player_move():
	if is_active:
		has_moved.emit()
	
	return
	
func object_collision(object : DynamicObject, direction : Vector2, move_distance : int):
	#old spagetti code from legacy move() code kept for reference
#	if (object.object_type == ObjectType.TRAP):
#			has_moved.emit()
#			walk.play()
#			hit.play()
#			move_object(direction, move_distance)
#			#Ensure anyone other then the rogue will die if they step on the trap
#			if (object_type != ObjectType.ROGUE):
#				player_death.emit()
#				
#	elif (object.object_type == ObjectType.ENEMY):
#		has_moved.emit()
#		walk.play()
#		hit.play()
#		move_object(direction, move_distance)
#		object.queue_free()		
#		
#	elif (object.object_type == ObjectType.TREASURE):
#		has_moved.emit()
#		walk.play()
#		move_object(direction, move_distance)
#		treasure_pickup.play()
#		
#	else:
#		return	
	pass
