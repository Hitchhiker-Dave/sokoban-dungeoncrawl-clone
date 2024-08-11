extends Enemy

#Similar to player, will need a enemy handler to determine when an enemy is allowed to act
@onready var arrow = preload("res://Objects/arrow.tscn")
@onready var ray_cast = $RayCast2D
@onready var sprite = $Sprite2D
@onready var warning = $Warning
@onready var target_direction

# Called when the node enters the scene tree for the first time.
func _ready():
	object_type = ObjectType.ENEMY
	is_movable = false
	move_distance = 32

func _process(_delta):
	target_direction = search_for_target(ray_cast)
	
	if (target_direction != null): #player was spotted on a cardinal
		warning.visible = true
		
		if target_direction.x > 0: 
			sprite.flip_h = false
		
		else: 
			sprite.flip_h = true
	else:
		warning.visible = false		

#do turn when enemy handler says so
func do_turn():
	if(target_direction != null):
		
		move_object(target_direction, move_distance)

func _on_area_2d_area_entered(area):
	var object = area.get_parent()
	if (is_player(object) == true):
		object.queue_free()
