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
		object.handle_death() #bad practice but this game should have been finished a month ago
		return
	
	return	

func _on_area_2d_area_entered(area):
	var object = area.get_parent()
	#die if run into trap
	if (object.object_type == ObjectType.TRAP):
		handle_death()
		
	#If you and an enemy overlap
	if (object.object_type == ObjectType.ENEMY):
		#you die if it's not your turn or you're not active
		if(!Global.player_turn or !is_active):
			handle_death()
			
	elif (object.object_type == ObjectType.EXIT):
		handle_level_transistion()

