extends Control

signal call_for_scene_change(scene : String)

func _on_ui_menu_ui_button_pressed(scene):
	call_for_scene_change.emit(scene)

func _on_ui_level_ui_button_pressed(scene):
	call_for_scene_change.emit(scene)

func _on_ui_level_2_ui_button_pressed(scene):
	call_for_scene_change.emit(scene)

func _on_ui_level_3_ui_button_pressed(scene):
	call_for_scene_change.emit(scene)

func _on_ui_level_4_ui_button_pressed(scene):
	call_for_scene_change.emit(scene)
