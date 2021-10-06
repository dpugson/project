extends Node2D

onready var animation = $AnimationPlayer2
onready var transition = Transition

var done = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Jukebox.play_song("res://tunes/therealdog.wav")
	animation.play("GO")

func gotobathroom():
	animation.play("THANK YOU")
	done = true

func _input(event):
	if not done:
		return
	if event.is_action_pressed("accept"):
		animation.play("GO_AWAY")
		Jukebox.stop()

func transition_away():
	transition.go_to("res://Levels/1.0 - Lab/Bathroom.tscn", "emerge_cutscene")

