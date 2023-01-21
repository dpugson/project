extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var leftSP = $leftSP
onready var rightSP = $rightSP
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var camera = $PuppyCamera

func _ready():
	var player_position = leftSP.global_position
	var orientation = Vector2.UP
	Jukebox.play_song("res://tunes/forest/sunset_train_ride.wav")
	match stats.spawn_metadata:
		"left":
			player_position = leftSP.global_position
			orientation = Vector2.UP
		"right":
			player_position = rightSP.global_position
			orientation = Vector2.RIGHT
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)


func _on_rightTZ_transition_triggered():
	pass # Replace with function body.

func _on_leftTZ_transition_triggered():
	pass # Replace with function body.
