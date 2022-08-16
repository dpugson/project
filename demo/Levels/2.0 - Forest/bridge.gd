extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var rightSP = $rightSP
onready var leftSP = $leftSP
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var camera = $PuppyCamera

func _ready():
	var player_position = rightSP.global_position
	var orientation = Vector2.LEFT
	Jukebox.play_song("res://tunes/starsong.wav")
	BgJukebox.play_song("res://tunes/mixkiteffects/strong_wind_cropped.wav")
	BgJukebox.set_volume(-10)
	match stats.spawn_metadata:
		"right":
			player_position = rightSP.global_position
			orientation = Vector2.LEFT
		"left":
			player_position = leftSP.global_position
			orientation = Vector2.RIGHT
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)

func _on_rightTZ_transition_triggered():
	BgJukebox.set_volume(-20)
	Transition.go_to("res://Levels/2.0 - Forest/foyer.tscn", "upper_left")

func _on_leftTZ_transition_triggered():
	BgJukebox.set_volume(-20)
	Transition.go_to("res://Levels/2.0 - Forest/little_study.tscn", "bottom")
