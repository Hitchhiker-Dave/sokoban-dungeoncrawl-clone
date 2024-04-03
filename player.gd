extends Node2D

var move_distance = 32
var tween: Tween
@onready var rigid_body_2d = $RigidBody2D

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
	#bootleg collision using raytracing; currently prevents any movement if there is a collision
	#gonna have to replace this with an actual raycast node/object since this doesn't actually get the object data
	
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters2D.create(global_position, target_position, 
													rigid_body_2d.get_collision_mask(), [self])
	var result = space_state.intersect_ray(query)
	#Collision Notes
	#result.collider.name = "ObjectNameHere"
	#tiles with colllision = "Tilemap"

	
	if result: #check if raycast actually hit something
		
		print(result.collider.name)
		print(result.position)
		#Wall Handling
		if result.collider.name == "TileMap":
			print("Hit Wall: ", result.position) 
			return
		elif result.collider.name == "RockCollision":
			print("Hit Rock")
			#get the object at the specific coords from result.position
			#may need to get a new raycast just for this

	if tween and tween.is_running():
		return
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", target_position, 0.16).set_trans(Tween.TRANS_BOUNCE)
	
