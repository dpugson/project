extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player

onready var bottomSP = $BottomSP

func _ready():
	Jukebox.play_song("res://tunes/crimbus/crimmas.wav")
	var player_position = bottomSP.position
	var orientation = Vector2.UP
	
	match stats.spawn_metadata:
		"bottom":
			player_position = bottomSP.position
			orientation = Vector2.UP
		_:
			pass
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)

func _on_TransitionZone_transition_triggered():
	Transition.go_to("res://Levels/22.0 Crimbus/BigRoom.tscn", "tree")
