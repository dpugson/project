extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

onready var rightSP = $RightSP

func _ready():
	var player_position = player.position
	var orientation = Vector2.DOWN
	Jukebox.play_song("res://Levels/21.0 Train/train_car/train_ride.wav")
	match stats.spawn_metadata:
		"right":
			player_position = rightSP.position
			orientation = Vector2.UP
		_:
			player_position = rightSP.position
			orientation = Vector2.UP
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)

func _on_BottomTZ_transition_triggered():
	Transition.go_to("res://Levels/21.0 Train/train_car_with_phone/train_car_with_phone.tscn", "stairs")
