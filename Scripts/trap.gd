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
	var object = area.get_parent()
	#replace with bootleg state machine that triggers disarm or triggered animation
	#(queue_free should trigger either way since trap is one use)
	if (object.object_type != ObjectType.ROGUE and is_player(object)):
		object.queue_free()
	queue_free()
