extends Node2D

@onready var player_list = self.get_children()
@onready var active_player
@onready var player_index = 0
@onready var player_count : int

# Called when the node enters the scene tree for the first time.
func _ready():
	active_player = player_list[player_index]
	active_player.is_active = true
	player_count = self.get_child_count()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	if Input.is_action_just_pressed("Next Character"):
		if (player_index +1) >= player_count:
			player_index = 0
		
		active_player.is_active = false
		player_index += 1
		active_player = player_list[player_index]
		active_player.is_active = true
		
