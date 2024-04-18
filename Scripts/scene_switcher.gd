extends Node
#Scene switcher global singleton
#based on this tutorial (9:35 min mark)

var current_scene = null
func _ready():
	var parent = get_node("/root/MainNode/LevelHandler")
	current_scene = parent.get_child(parent.get_child_count() - 1)

func switch_scene(res_path):
	call_deferred("_deferred_switch_scene", res_path)
	
func _deferred_switch_scene(res_path):
	current_scene.free()
	var s = load(res_path)
	current_scene = s.instantiate()
	get_node("/root/MainNode/LevelHandler").add_child(current_scene)
	get_tree().current_scene = current_scene
