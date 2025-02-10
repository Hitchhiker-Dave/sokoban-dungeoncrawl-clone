extends Node2D

@onready var player_list = self.get_children()
@onready var active_player
@onready var player_index = 0
@onready var player_count : int
@onready var player_reached_level_transition = false
signal ready_for_next_level
signal player_moved
signal level_exited

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for i in range(player_list.size()):
		get_node(player_list[i].to_string()).hit_level_transition.connect(handle_player_leaving)
		
		get_node(player_list[i].to_string()).player_death.connect(remove_player)
		get_node(player_list[i].to_string()).has_moved.connect(end_player_turn)
		
	#active_player handling between scene transistions
	active_player = player_list[player_index]
	if Input.is_anything_pressed():
		active_player.stop_ghost_movement()
		
	active_player.is_active = true
	active_player.marker.show()
	player_count = player_list.size()
		
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
	if player_count > 0: #only swap players when there are any characters left
		player_index += increment
		if player_index > (player_list.size() - 1):
				player_index = 0
		elif player_index <= -1:
			player_index = player_count - 1
			
		if (active_player != null):
			active_player.marker.hide()
			active_player.is_active = false
			
		active_player = player_list[player_index]
		if (active_player != null and Input.is_anything_pressed()):
			active_player.stop_ghost_movement()
		
		if (active_player != null):
			active_player.is_active = true		
			active_player.marker.show()		
		
func handle_player_leaving():
	player_reached_level_transition = true
	level_exited.emit()
	remove_player()

func remove_player():
	await swap_player(1)
	player_list.remove_at(player_index)
	player_count -= 1
		
func toggle_activity():
	if active_player == null:
		return #prevent null error via early exits
		
	active_player.is_active = !active_player.is_active
		
func end_player_turn():
	player_moved.emit()
	
func get_player_count():
	return player_count
