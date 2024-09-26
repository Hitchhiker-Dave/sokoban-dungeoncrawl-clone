extends Player

# Called when the node enters the scene tree for the first time.
func _ready():
	move_distance = 32
	object_type = ObjectType.FIGHTER

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#Fighter Centric Interactions
func object_collision(object :DynamicObject, direction :Vector2, move_distance : int):
	#Fighter Runs into Trap -> Dead ()
	if (object.object_type == ObjectType.TRAP):
		has_moved.emit()
		AudioHandler.play_sfx("Walk", 0.9, 1.1)
		AudioHandler.play_sfx("Hit", 0.9, 1.1)
		move_object(direction, move_distance)
		handle_death()
		return
	
	#Fighter Survives Running into ENEMY -> Dead Enemy
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
	
	#Enemy/Arrow goes into Fighter -> Destroy Enemy/Arrow
	if (object.object_type == ObjectType.ENEMY):
		AudioHandler.play_sfx("Hit", 0.9, 1.1)
		object.queue_free()
