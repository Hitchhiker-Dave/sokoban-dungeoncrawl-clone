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
		#play_sound(walk, 0.9, 1.1)
		AudioHandler.play_sfx("Walk", 0.9, 1.1)
		move_object(direction, move_distance)
		return
	
	#Rogue Survives Running into ENEMY -> Enemy death handled on their end
	elif (object.object_type == ObjectType.ENEMY):
		AudioHandler.play_sfx("Walk", 0.9, 1.1)
		move_object(direction, move_distance)
		object.handle_death() #bad practice but this game should have been finished a month ago
		return
	
	return	

func _on_area_2d_area_entered(area):
	var object = area.get_parent()
	#Arrow goes into Rogue -> Rogue Dies
	if (object.object_type == ObjectType.PROJECTILE):
		await handle_death()

	#If you and an enemy overlap
	if (object.object_type == ObjectType.ENEMY):
		#you die if it's not your turn or you're not active
		if(!Global.player_turn or !is_active):
			await handle_death()
			
	elif (object.object_type == ObjectType.EXIT):
		handle_level_transistion()
