extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# basic "tile movement"
	# for some reason the analogue controls are inverted for the left stick
	if (Input.is_action_just_released("Move Up")):
		position.y = position.y - 50
	if (Input.is_action_just_released("Move Down")):
		position.y = position.y + 50
	if (Input.is_action_just_released("Move Left")):
		position.x = position.x - 50
	if (Input.is_action_just_released("Move Right")):
		position.x = position.x + 50
