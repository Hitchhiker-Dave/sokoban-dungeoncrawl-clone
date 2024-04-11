extends Node2D

var move_distance = 32
var tween: Tween
@onready var active_manager = get_parent()
@onready var area_2d = $Area2D
@onready var ray_cast_2d = $RayCast2D
@onready var tile_map = $"../../TileMap"
@export var player_id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	#check if player is controlling this paticular character
	var is_active = active_manager.active_player
	
	if is_active == player_id: #if true, you can move the player
		# basic "tile movement"
		# for some reason the analogue controls are inverted for the left stick
		#convert to vector movement; should work fine if I keep the update on a key release
		
		if (Input.is_action_just_pressed("Move Up")):
			move(Vector2.UP)
		if (Input.is_action_just_pressed("Move Down")):
			move(Vector2.DOWN)
		if (Input.is_action_just_pressed("Move Left")):
			move(Vector2.LEFT)
		if (Input.is_action_just_pressed("Move Right")):
			move(Vector2.RIGHT)

func move(direction: Vector2):
	
	#movement and animation
	var target_move_position = global_position + direction * move_distance
	
	#Get current tile Vector2i
	var current_tile : Vector2i = tile_map.local_to_map(global_position)
	
	#Get target tile Vector2i
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y
	)
	#Get custom data layer from target tile
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	
	if tile_data.get_custom_data("walkable") == false:
		return
	
	#raycast
	ray_cast_2d.target_position = direction * move_distance
	ray_cast_2d.force_raycast_update()
	
	if ray_cast_2d.is_colliding():
		ray_cast_2d.get_collider().get_parent().move(direction) 
		return

	if tween and tween.is_running():
		return
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", target_move_position, 0.16).set_trans(Tween.TRANS_BOUNCE)
