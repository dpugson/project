extends Node2D

onready var anim = $holder/shaker

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.playback_speed = rand_range(.3, 1.2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
