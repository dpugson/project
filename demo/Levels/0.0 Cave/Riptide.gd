extends Node2D

onready var animation = $AnimationPlayer2
onready var transition = Transition

# Called when the node enters the scene tree for the first time.
func _ready():
	Jukebox.play_song("res://tunes/therealdog.wav")
	animation.play("GO")

func gotobathroom():
	pass
	#transition.go_to("res://Levels/0.1 Lab/Bathroom.tscn", "top")
