extends Control

signal ui_button_pressed(scene : String)

@onready var button = $Button
@export var padding : float
@export var scene : String
@export var button_label : String

# Called when the node enters the scene tree for the first time.
func _ready():
	button.text = button_label
	custom_minimum_size.x = button.size.x + (padding)
	custom_minimum_size.y = button.size.y + (padding)

func _on_button_pressed():
	ui_button_pressed.emit(scene)
