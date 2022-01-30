extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var bottomSP = $bottomSP
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var camera = $PuppyCamera

func _ready():
	var player_position = bottomSP.global_position
	var orientation = Vector2.UP
	Jukebox.play_song("res://tunes/deserted_town_instrumental.wav")
	match stats.spawn_metadata:
		"bottom":
			player_position = bottomSP.global_position
			orientation = Vector2.UP
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)

func _on_topTZ_transition_triggered():
	Transition.go_to("res://Levels/2.0 - Forest/town/mayors_house/mayors_house_upstairs.tscn", "bottom")

func _on_HurtBox_area_entered(_area):
	pass
