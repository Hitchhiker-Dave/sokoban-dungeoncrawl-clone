extends DynamicObject

@onready var sprite = $Sprite2D
@onready var area = $Area2D

signal picked_up

# Called when the node enters the scene tree for the first time.
func _ready():
	object_type = ObjectType.TREASURE

func _on_area_2d_area_entered(area):
	await AudioHandler.play_sfx("Treasure_Pickup", 0.9, 1.1)
	area.monitoring = false
	picked_up.emit()
	queue_free()
