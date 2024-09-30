extends Node2D

signal treasure_looted

@onready var treasure_list := self.get_children()
var total_treasure : int

# Called when the node enters the scene tree for the first time.
func _ready():
	total_treasure = treasure_list.size()
	
	for i in (total_treasure):
		get_node(treasure_list[i].to_string()).picked_up.connect(update_treasure_count)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_treasure_count():
	treasure_looted.emit()

func get_total_treasure():
	return total_treasure
