extends Enemy

#Similar to player, will need a enemy handler to determine when an enemy is allowed to act
@onready var arrow = preload("res://Objects/arrow.tscn")
@onready var ray_cast = $RayCast2D
@onready var sprite = $Sprite2D
@onready var warning = $Warning
@onready var timer = $Timer

@onready var target_direction 
@onready var last_spotted : Vector2
@onready var just_fired := false

# Called when the node enters the scene tree for the first time.
func _ready():
	object_type = ObjectType.ENEMY
	is_movable = false

func _process(_delta):
	target_direction = search_for_target(ray_cast)
	
	if (target_direction != null): #player was spotted on a cardinal
		warning.visible = true
		last_spotted = target_direction 
		
		if target_direction.x < 0: 
			sprite.flip_h = true
		
		else: 
			sprite.flip_h = false
	elif just_fired:
		warning.visible = true
	else:
		warning.visible = false		

#do turn when enemy handler says so
func do_turn():
	#print("Enemy Turn, target direction: ", target_direction)
	if(target_direction != null):
		var instance = arrow.instantiate()
		instance.facing = last_spotted
		add_sibling(instance)
		instance.position = global_position
		instance.tile_map = tile_map
		timer.start()
		just_fired = true

func _on_timer_timeout():
	just_fired = false
