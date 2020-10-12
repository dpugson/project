extends Node2D
 
onready var animation = $AnimationPlayer

func _ready():
	Jukebox.play_song("res://tunes/therealdog.wav")
	animation.play("prologue")

func finished():
	Transition.go_to("res://Levels/0.0 Cave/Cave01.tscn")
