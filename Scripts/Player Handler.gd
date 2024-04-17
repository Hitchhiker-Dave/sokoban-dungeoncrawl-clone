extends Node2D

@onready var active_player = 1 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#Fighter = 1, Wizard = 2, Thief = 3
	if Input.is_action_just_pressed("Next Character"):
		if active_player != 3:
			active_player += 1
		else:
			active_player = 1
