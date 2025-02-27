extends DynamicObject
#will be the only thing to break the rules of the game by not moving in a grid

var facing : Vector2
@onready var ray_cast_2d = $RayCast2D
@onready var sprite_2d = $Sprite2D
var check_distance : int

# Called when the node enters the scene tree for the first time.
func _ready():
	object_type = ObjectType.PROJECTILE
	move_distance = 1000
	check_distance = 16 #arrow is 5 pixels "long"
	sprite_2d.look_at(facing)
	ray_cast_2d.target_position = facing * check_distance
	AudioHandler.play_sfx("Shoot", 0.9, 1.1)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (not is_walkable(Vector2.ZERO, move_distance)):
		#collided with wall
		queue_free()
		return
	
	var collider = get_collider(ray_cast_2d, facing, check_distance)
	
	if (collider != null):
		var object = collider.get_parent()
			
		#Delete Arrow if it hits rock
		if (object.object_type == ObjectType.ENVIRONMENT):
			queue_free()
			
	position += facing * move_distance * delta

func _on_area_2d_area_entered(area):
	print(area)
	var object = area.get_parent()
	if (object.object_type == ObjectType.ENEMY): 
		return
	
	if (object.object_type == ObjectType.FIGHTER):
		AudioHandler.play_sfx("Cant_Move", 0.9, 1.1)
	elif (self.is_player(object)):
		AudioHandler.play_sfx("Hit", 0.9, 1.1)
		
	queue_free()
