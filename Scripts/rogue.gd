extends Player

# Called when the node enters the scene tree for the first time.
func _ready():
	move_distance = 32
	object_type = ObjectType.ROGUE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#prevent rogue from being able to push rocks
func push_object(object :DynamicObject, direction :Vector2, move_distance : int):
	AudioHandler.play_sfx("Cant_Move", 0.9, 1.1)
	move_failed(direction, move_distance)
	return

#Rogue Centric Interactions
func object_collision(object :DynamicObject, direction :Vector2, move_distance : int):
	#Rogue Runs into Boulder -> Fails to Push
	if (object.object_type == ObjectType.ENVIRONMENT):
		return
	
	#Rogue Runs into Trap -> Disarmed
	if (object.object_type == ObjectType.TRAP):
		has_moved.emit()
		#play_sound(walk, 0.9, 1.1)
		AudioHandler.play_sfx("Walk", 0.9, 1.1)
		AudioHandler.play_sfx("Hit", 0.9, 1.1)
		move_object(direction, move_distance)
		return
	
	#Rogue Survives Running into ENEMY -> Dead Enemy
	elif (object.object_type == ObjectType.ENEMY):
		has_moved.emit()
		AudioHandler.play_sfx("Walk", 0.9, 1.1)
		AudioHandler.play_sfx("Hit", 0.9, 1.1)
		object.queue_free()
		move_object(direction, move_distance)
		return
	
	return	

func _on_area_2d_area_entered(area):
	var object = area.get_parent()
	
	#Enemy/Arrow goes into Rogue -> Rogue Dies
	if (object.object_type == ObjectType.ENEMY or object.object_type == ObjectType.PROJECTILE):
		AudioHandler.play_sfx("Hit", 0.9, 1.1)
		handle_death()
