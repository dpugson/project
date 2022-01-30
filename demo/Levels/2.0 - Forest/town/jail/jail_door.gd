extends Node2D

onready var animation = $AnimatedSprite
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func open():
	animation.animation = "open"
	animation.frame = 0

func close():
	animation.animation = "close"
	animation.frame = 0
