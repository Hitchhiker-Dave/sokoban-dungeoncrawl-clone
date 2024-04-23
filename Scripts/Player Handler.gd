extends Node2D

@onready var player_list = self.get_children()
@onready var active_player
@onready var player_index = 0
@onready var player_count : int
@onready var player_reached_level_transition = false
signal ready_for_next_level
signal player_moved

# Called when the node enters the scene tree for the first time.
func _ready():
	active_player = player_list[player_index]
	active_player.is_active = true
	player_count = player_list.size()
	
	for i in range(player_list.size()):
		get_node(player_list[i].to_string()).hit_level_transition.connect(_handle_player_leaving)
		get_node(player_list[i].to_string()).player_death.connect(_remove_player)
		get_node(player_list[i].to_string()).has_moved.connect(end_player_turn)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_count <= 0: #no more players, handle win lose state
		if player_reached_level_transition:
			ready_for_next_level.emit() 

	if Input.is_action_just_pressed("Next Character"):
		swap_player(1)
		
	elif Input.is_action_just_pressed("Previous Character"):
		swap_player(-1)

func swap_player(increment : int):
	player_index += increment
	if player_index > (player_list.size() - 1):
			player_index = 0
	elif player_index <= -1:
		player_index = player_count - 1
		
	if (active_player != null):
		active_player.is_active = false
		
	active_player = player_list[player_index]
	active_player.is_active = true		
		
func _handle_player_leaving():
	player_reached_level_transition = true
	_remove_player()

func _remove_player():
	player_list.remove_at(player_index)
	player_count -= 1
	if player_count > 0:
		swap_player(1)
		
func toggle_activity():
	if active_player.is_active:
		active_player.is_active = false
	else:
		active_player.is_active = true
		
func end_player_turn():
	player_moved.emit()
	
