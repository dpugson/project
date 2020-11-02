extends Node2D

func _ready():
	Jukebox.play_song("res://tunes/starsong.wav")

var ready_to_go = false

func accept_input():
	ready_to_go = true

func _input(event):
	if ready_to_go:
		if event.is_action_pressed("accept"):
			Transition.go_to("res://MainMenu/MainMenu.tscn")
