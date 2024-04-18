extends Node2D

@onready var player_list = self.get_children()
@onready var active_player
@onready var player_index = 0
@onready var player_count : int
@onready var player_reached_level_transition = false
signal ready_for_next_level

# Called when the node enters the scene tree for the first time.
func _ready():
	active_player = player_list[player_index]
	active_player.is_active = true
	player_count = player_list.size()
	
	for i in range(player_list.size()):
		get_node(player_list[i].to_string()).hit_level_transition.connect(_handle_player_leaving)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_count <= 0: #no more players, handle win lose state
		if player_reached_level_transition:
			print("Send Signal to Transition to Next Level (Player Handler)")
			ready_for_next_level.emit() 

	if Input.is_action_just_pressed("Next Character"):
		player_index += 1
		if player_index > (player_list.size() - 1):
			player_index = 0
		
		active_player.is_active = false
		active_player = player_list[player_index]
		active_player.is_active = true
		
	elif Input.is_action_just_pressed("Previous Character"):
		player_index -= 1
		if player_index <= -1:
			player_index = player_count - 1
		
		active_player.is_active = false
		active_player = player_list[player_index]
		active_player.is_active = true
		
func _handle_player_leaving():
	print("Signal Recived! (Player Handler)")
	player_reached_level_transition = true
	active_player.queue_free()
	player_count -= 1
