extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var bottomSP = $BottomSP
onready var animation = $AnimationPlayer

onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

var ROBOT_PITCH = 2
var ROBOT_SPEECH_SPEED = 0.05

func _ready():
	var player_position = Vector2.ZERO
	var orientation = Vector2.UP
	match stats.spawn_metadata:
		"door":
			Jukebox.play_song("res://tunes/lab/background_science.wav")
			player_position = bottomSP.position
			orientation = Vector2.UP
		_:
			Jukebox.play_song("res://tunes/lab/background_science.wav")
			player_position = bottomSP.position
			orientation = Vector2.UP
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)
