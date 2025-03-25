extends Enemy
class_name Skeleton

#Similar to player, will need a enemy handler to determine when an enemy is allowed to act
@onready var arrow = preload("res://Objects/arrow.tscn")
@onready var ray_cast = $RayCast2D
@onready var sprite = $Sprite2D
@onready var warning = $Warning
@onready var timer = $Timer

@onready var target_direction 
@onready var last_spotted
@onready var just_fired := false
@onready var in_melee := false

# Called when the node enters the scene tree for the first time.
func _ready():
	object_type = ObjectType.ENEMY
	is_movable = false

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
	if(target_direction == null or just_fired):
		has_moved.emit(global_position) #tell enemy handler the skeleton is finished and its current position
		return
	
	#don't shoot via early return if target is in melee
	if (check_if_in_melee(ray_cast, target_direction)) : 
		has_moved.emit(global_position) #tell enemy handler the skeleton is finished and its current position
		return
	
	if (last_spotted):
		just_fired = true
		var instance = arrow.instantiate()
		instance.facing = last_spotted
		add_sibling(instance)
		instance.position = global_position
		instance.tile_map = tile_map
		timer.start()
		last_spotted = null
	
	has_moved.emit(global_position) #tell enemy handler the skeleton is finished and its current position	
	
func _on_timer_timeout():
	just_fired = false

func _on_hurtbox_area_entered(area):
	if (area.get_parent().object_type == ObjectType.PROJECTILE):
		return
		
	AudioHandler.play_sfx("Hit", 0.9, 1.1)
