extends DynamicObject

@onready var sprite = $Sprite2D
@onready var treasure_pickup = $treasure_pickup
@onready var timer = $Timer #temp solution until animation allows sound to fully play
@onready var area = $Area2D

var picked_up = false

# Called when the node enters the scene tree for the first time.
func _ready():
	object_type = ObjectType.TREASURE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (picked_up):
		if !treasure_pickup.playing:
			play_sound(treasure_pickup, 0.9, 1.1)
		
		if timer.time_left <= 0:
			queue_free()

func _on_area_2d_area_entered(area):
	picked_up = true
	sprite.visible = false
	area.monitoring = false
	area.monitorable = false
	timer.start()
