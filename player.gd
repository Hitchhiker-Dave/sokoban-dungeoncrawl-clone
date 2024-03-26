extends Node2D

var move_distance = 32
var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# basic "tile movement"
	# for some reason the analogue controls are inverted for the left stick
	#convert to vector movement; should work fine if I keep the update on a key release
	
	if (Input.is_action_just_pressed("Move Up")):
		move(Vector2.UP)
	if (Input.is_action_just_pressed("Move Down")):
		move(Vector2.DOWN)
	if (Input.is_action_just_pressed("Move Left")):
		move(Vector2.LEFT)
	if (Input.is_action_just_pressed("Move Right")):
		move(Vector2.RIGHT)

func move(direction: Vector2):
	
	#movement and animation
	var target_position = global_position + direction * move_distance
	
	#implement look ahead here; for collisions and interactables
	#look up raycasting 
	
	if tween and tween.is_running():
		return
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", target_position, 0.16).set_trans(Tween.TRANS_BOUNCE)
	
