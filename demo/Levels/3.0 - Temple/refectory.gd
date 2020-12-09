extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var leftSP = $leftSP

onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

func _ready():
	var player_position = leftSP.position
	var orientation = Vector2.RIGHT
	match stats.spawn_metadata:
		"left":
			#Jukebox.play_song("res://tunes/lab/background_science.wav")
			player_position = leftSP.position
			orientation = Vector2.RIGHT
		_:
			pass
			
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)
