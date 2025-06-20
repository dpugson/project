extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

onready var rightSP = $RightSP
onready var stairsSP = $StairsSP

func _ready():
	var player_position = player.position
	var orientation = Vector2.DOWN
	Jukebox.play_song("res://Levels/21.0 Train/train_car/train_ride.wav")
	match stats.spawn_metadata:
		"right":
			player_position = rightSP.position
			orientation = Vector2.LEFT
		"stairs":
			player_position = stairsSP.position
			orientation = Vector2.DOWN
		_:
			player_position = rightSP.position
			orientation = Vector2.LEFT
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)


func _on_StairsTZ_transition_triggered():
	Transition.go_to("res://Levels/21.0 Train/observation_train_car/observation_train_car.tscn", "right")
