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
	#Fighter Runs into Trap -> Death handled by on_area2d_area_entered()
	if (object.object_type == ObjectType.TRAP):
		AudioHandler.play_sfx("Walk", 0.9, 1.1)
		move_object(direction, move_distance)
		return
	
	#Fighter Survives Running into ENEMY -> Enemy death handled on their end
	elif (object.object_type == ObjectType.ENEMY):
		AudioHandler.play_sfx("Walk", 0.9, 1.1)
		move_object(direction, move_distance)
		return
	
	return	

func _on_area_2d_area_entered(area):
	var object = area.get_parent()
	
	if (object.object_type == ObjectType.TRAP):
		handle_death()
