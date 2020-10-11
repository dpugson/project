extends Node2D

signal done

onready var pink = $Sprite/pink 
onready var green = $Sprite/green
 
func _ready():
	if rand_range(0, 1) >= 0.6:
		green.visible = true
	else:
		pink.visible = true

func done():
	emit_signal("done")
