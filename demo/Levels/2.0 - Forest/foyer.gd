extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var upper_leftSP = $upper_leftSP
onready var bottomSP = $bottomSP
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var camera = $PuppyCamera

func _ready():
	var player_position = bottomSP.global_position
	var orientation = Vector2.UP
	Jukebox.play_song("res://tunes/starsong.wav")
	match stats.spawn_metadata:
		"bottom":
			player_position = bottomSP.global_position
			orientation = Vector2.UP
		"upper_left":
			player_position = upper_leftSP.global_position
			orientation = Vector2.RIGHT
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)

func _on_bottomTZ_transition_triggered():
	Transition.go_to("res://Levels/1.0 - Lab/labhallway.tscn", "lab")

func _on_upperLeftTZ_transition_triggered():
	Transition.go_to("res://Levels/2.0 - Forest/bridge.tscn", "right")
