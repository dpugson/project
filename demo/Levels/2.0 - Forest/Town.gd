extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var teaShopSpawnPoint = $TeaShopSpawnPoint
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

var ROBOT_PITCH = 2
var ROBOT_SPEECH_SPEED = 0.05

func _ready():
	var player_position = player.position
	var orientation = Vector2.DOWN
	var spawn_player = true
	match stats.spawn_metadata:
		_:
			#Jukebox.play_song("res://tunes/lab/background_science.wav")
			player_position = teaShopSpawnPoint.position
			orientation = Vector2.RIGHT
	if spawn_player:
		stats.spawn_player(
			player, null, 
			"../../../PuppyCamera", player_position, orientation)
