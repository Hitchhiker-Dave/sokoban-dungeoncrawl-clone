extends DynamicObject
#transfer disarm and triggered sounds here so I don't have audio spagethii

# Called when the node enters the scene tree for the first time.
func _ready():
	object_type = ObjectType.TRAP
	is_movable = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	#early exit if (theoretically) a charger (only enemy that moves)
	if (area.get_parent().object_type == ObjectType.ENEMY):
		return
	
	AudioHandler.play_sfx("Hit", 0.9, 1.1)
	queue_free()
