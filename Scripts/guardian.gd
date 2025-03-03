extends Enemy
class_name Guardian

#Similar to player, will need a enemy handler to determine when an enemy is allowed to act
@onready var arrow = preload("res://Objects/arrow.tscn")
@onready var ray_cast = $RayCast2D
@onready var sprite = $Sprite2D
@onready var warning = $Warning
@onready var target_direction 
@onready var last_spotted
@onready var just_moved : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	object_type = ObjectType.ENEMY
	is_movable = false
	move_distance = 32
	has_moved.emit(global_position)

func _process(_delta):
	target_direction = search_for_target(ray_cast)
	
	if (target_direction != null) and Global.player_turn: #player was spotted on a cardinal
		warning.visible = true
		last_spotted = target_direction
		
		if target_direction.x < 0: 
			sprite.flip_h = true
		
		else: 
			sprite.flip_h = false
	else:
		warning.visible = false		

#do turn when enemy handler says so
func do_turn():
	if(last_spotted):
		if(check_if_tile_is_free(last_spotted, move_distance)): await move_object(last_spotted, move_distance)
		
		
	last_spotted = null
	has_moved.emit(global_position)
