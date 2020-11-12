extends Node2D

export(String, MULTILINE) var text = "STAR CHILD, YOU CANNOT GIVE UP!!!\nGET UP AND TRY AGAIN!!!\nWE BELIEVE IN YOU!"
export(String) var go_to = "res://MainMenu/MainMenu.tscn"

onready var stats = PlayerStats

func _ready():
	Jukebox.play_song("res://tunes/starsong.wav")
	stats.health = stats.max_health
	$Label.text = text

var ready_to_go = false

func accept_input():
	ready_to_go = true

func _input(event):
	if ready_to_go:
		if event.is_action_pressed("accept"):
			Transition.go_to(go_to)
