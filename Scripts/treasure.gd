extends DynamicObject

@onready var sprite = $Sprite2D
@onready var area = $Area2D
@onready var coin_vfx = preload("res://Objects/coin_vfx.tscn")

signal picked_up

# Called when the node enters the scene tree for the first time.
func _ready():
	object_type = ObjectType.TREASURE

func _on_area_2d_area_entered(area):
	await AudioHandler.play_sfx("Treasure_Pickup", 0.9, 1.1)
	picked_up.emit()
	onPickup()
	queue_free()

func onPickup():
	var instance = coin_vfx.instantiate()
	add_sibling(instance)
	instance.position = global_position
	instance.position.y -= 24
