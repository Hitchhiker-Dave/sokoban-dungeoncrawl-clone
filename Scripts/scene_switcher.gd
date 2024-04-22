extends Node
#Scene switcher global singleton
#based on this tutorial (9:35 min mark) https://www.youtube.com/watch?v=RMdf60IAxY0

var current_scene = null
func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func switch_scene(res_path):
	call_deferred("_deferred_switch_scene", res_path)
		
func _deferred_switch_scene(res_path):
	print(current_scene)
	if is_instance_valid(current_scene):
		current_scene.free()
	var s = load(res_path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
