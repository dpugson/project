extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var leftSP = $leftSP

onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

func _process(delta):
	var offset = (1100 - player.global_position.y) / 3000
	var value = 1.3 - offset
	player.scale = Vector2(value, value)

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
