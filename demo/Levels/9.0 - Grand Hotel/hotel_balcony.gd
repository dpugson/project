extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var topSP = $topSP
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var camera = $PuppyCamera

func _ready():
	var player_position = topSP.global_position
	var orientation = Vector2.DOWN
	Jukebox.play_song("res://tunes/forest/sunny_morning.wav")
	match stats.spawn_metadata:
		"top":
			player_position = topSP.global_position
			orientation = Vector2.DOWN
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)

func _on_topTZ_transition_triggered():
	Transition.go_to("res://Levels/9.0 - Grand Hotel/hotel_room.tscn", "top")
