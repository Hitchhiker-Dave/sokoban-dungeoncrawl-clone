extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.play("default")

func _on_animated_sprite_2d_animation_finished():
	queue_free()
