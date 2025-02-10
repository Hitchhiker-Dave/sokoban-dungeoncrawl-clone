extends Enemy

#Similar to player, will need a enemy handler to determine when an enemy is allowed to act
@onready var arrow = preload("res://Objects/arrow.tscn")
@onready var ray_cast = $RayCast2D
@onready var sprite = $Sprite2D
@onready var warning = $Warning
@onready var move_timer = $Move_Timer
@onready var target_direction 
@onready var just_moved : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	object_type = ObjectType.ENEMY
	is_movable = false
	move_distance = 32
	just_moved = false

func _process(_delta):
	target_direction = search_for_target(ray_cast)
	
	if (target_direction != null): #player was spotted on a cardinal
		warning.visible = true
		
		if target_direction.x < 0: 
			sprite.flip_h = true
		
		else: 
			sprite.flip_h = false
	else:
		warning.visible = false		

#do turn when enemy handler says so
func do_turn():
	if(target_direction != null and !just_moved and !check_for_allies(ray_cast, target_direction)):
		just_moved = true
		move_timer.start()
		move_object(target_direction, move_distance)
	has_moved.emit()
		
	#too much of a hassle to kill guardian from here, 
	#just let the player call for it and figure out how to do better next project 

func _on_move_timer_timeout():
	just_moved = false

