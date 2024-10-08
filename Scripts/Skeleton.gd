extends Enemy

#Similar to player, will need a enemy handler to determine when an enemy is allowed to act
@onready var arrow = preload("res://Objects/arrow.tscn")
@onready var ray_cast = $RayCast2D
@onready var sprite = $Sprite2D
@onready var warning = $Warning
@onready var target_direction 
@onready var last_spotted
@onready var target_spotted

# Called when the node enters the scene tree for the first time.
func _ready():
	object_type = ObjectType.ENEMY
	is_movable = false

func _process(_delta):
	var target_direction = search_for_target(ray_cast)
	
	if (target_direction != null): #player was spotted on a cardinal
		warning.visible = true
		#these two variables existing are 100% nessassary for firing arrows on the next player turn
		#(could patch into the chaser enemy too)
		target_spotted = true
		last_spotted = target_direction 
		
		if target_direction.x > 0: 
			sprite.flip_h = false
		
		else: 
			sprite.flip_h = true
	else:
		target_spotted = false
		warning.visible = false		

#do turn when enemy handler says so
func do_turn():
	print("Enemy Turn, target direction: ", target_direction)
	if(target_spotted):
		var instance = arrow.instantiate()
		instance.facing = last_spotted
		add_sibling(instance)
		instance.position = global_position
		instance.tile_map = tile_map
