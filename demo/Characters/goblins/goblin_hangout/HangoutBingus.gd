extends Node2D

onready var animation = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Timer_timeout():
	animation.frame = 0
