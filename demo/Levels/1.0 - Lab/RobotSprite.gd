extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func left():
	self.animation = "left"

func right():
	self.animation = "right"

func up():
	self.animation = "up"

func down():
	self.animation = "down"
