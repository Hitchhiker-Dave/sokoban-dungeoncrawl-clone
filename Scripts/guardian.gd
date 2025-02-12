extends Enemy

#Similar to player, will need a enemy handler to determine when an enemy is allowed to act
@onready var arrow = preload("res://Objects/arrow.tscn")
@onready var ray_cast = $RayCast2D
@onready var sprite = $Sprite2D
@onready var warning = $Warning
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
	if(target_direction != null and check_if_tile_is_free(target_direction, move_distance)):
		just_moved = true
		await move_object(target_direction, move_distance)
		has_moved.emit(global_position + (target_direction * move_distance))
	else:
		has_moved.emit(global_position)
	#too much of a hassle to kill guardian from here, 
	#just let the player call for it and figure out how to do better next project 

