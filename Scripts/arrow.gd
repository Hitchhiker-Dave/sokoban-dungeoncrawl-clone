extends DynamicObject
#will be the only thing to break the rules of the game by not moving in a grid

var facing : Vector2
@onready var ray_cast_2d = $RayCast2D
@onready var sprite_2d = $Sprite2D
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
var check_distance : int

# Called when the node enters the scene tree for the first time.
func _ready():
	object_type = ObjectType.ENEMY
	move_distance = 16
	check_distance = 32
	sprite_2d.look_at(facing)
	ray_cast_2d.target_position = facing * check_distance
	audio_stream_player_2d.play() #should probably play this from the skeleton
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (not is_walkable(facing, move_distance)):
		#collided with wall
		queue_free()
		return
	
	var collider = get_collider(ray_cast_2d, facing, check_distance)
	
	if (collider != null):
		var object = collider.get_parent()
			
		if (object.object_type == ObjectType.ENVIRONMENT):
			queue_free()
			
	position += facing * move_distance
