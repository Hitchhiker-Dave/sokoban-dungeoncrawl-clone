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
@onready var in_melee := false

# Called when the node enters the scene tree for the first time.
func _ready():
	object_type = ObjectType.ENEMY
	is_movable = false

func _process(_delta):
	target_direction = search_for_target(ray_cast)
	
	if (target_direction != null): #player was spotted on a cardinal
		last_spotted = target_direction 
		warning.visible = true
		
		if target_direction.x < 0: 
			sprite.flip_h = true
		
		else: 
			sprite.flip_h = false
	elif just_fired or target_direction == null:
		warning.visible = false

#do turn when enemy handler says so
func do_turn():
	if(target_direction == null):
		return
	
	#don't shoot via early return if target is in melee
	if (check_if_in_melee(ray_cast, target_direction)) : 
		return
	
	var instance = arrow.instantiate()
	instance.facing = last_spotted
	add_sibling(instance)
	instance.position = global_position
	instance.tile_map = tile_map
	timer.start()
	just_fired = true

func _on_timer_timeout():
	just_fired = false

func _on_hurtbox_area_entered(area):
	if (area.get_parent().object_type == ObjectType.PROJECTILE):
		return
		
	AudioHandler.play_sfx("Hit", 0.9, 1.1)
	queue_free()
