extends DynamicObject

@onready var sprite = $Sprite2D
@onready var area = $Area2D

var picked_up = false

# Called when the node enters the scene tree for the first time.
func _ready():
	object_type = ObjectType.TREASURE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (picked_up):
		await AudioHandler.play_sfx("Treasure_Pickup", 0.9, 1.1)
		queue_free()

func _on_area_2d_area_entered(area):
	picked_up = true
	area.monitoring = false
