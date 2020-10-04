extends Node2D

onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func open():
	animation_state.travel("Opening")
	
func close():
	animation_state.travel("Closing")
