extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var doorSP = $DoorSP

func _ready():
	var player_position = Vector2.ZERO
	var orientation = Vector2.UP
	match stats.spawn_metadata:
		"door":
			Jukebox.play_song("res://tunes/lab/background_science.wav")
			player_position = doorSP.position
			orientation = Vector2.UP
		"emerge_cutscene":
			# TODO
			player.visible = false
			player.cutscene_mode = true
		_:
			Jukebox.play_song("res://tunes/lab/background_science.wav")
			player_position = doorSP.position
			orientation = Vector2.UP
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)

func _on_DoorTZ_transition_triggered():
	Transition.go_to("res://Levels/1.0 - Lab/labhallway.tscn", "break_room")
