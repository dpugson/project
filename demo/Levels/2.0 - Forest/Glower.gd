extends Node2D

onready var animation_player = $AnimationPlayer
# Called when the node enters the scene tree for the first time.

func _ready():
	var start = int(rand_range(0, animation_player.current_animation_length))
	print(start)
	animation_player.seek(start)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
