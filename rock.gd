extends Node2D

var direction = Vector2.ZERO
var move_distance = 32
var tween : Tween
@onready var tile_map = $"../TileMap"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func move(direction: Vector2):
	var target_position = self.global_position + direction * move_distance

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
		
	if tween and tween.is_running():
		return
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", target_position, 0.16).set_trans(Tween.TRANS_BOUNCE)
	return
