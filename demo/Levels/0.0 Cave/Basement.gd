extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var transition = Transition
onready var pillowSP = $PillowSpawnPoint
onready var doorSP = $DoorSpawnPoint

func _ready():
	Jukebox.play_song("res://tunes/cave/fallen.wav")
	var player_position = Vector2.ZERO
	var orientation = Vector2.DOWN
	match stats.spawn_metadata:
		"pillow":
			player_position = pillowSP.position
			orientation = Vector2.DOWN
		"door":
			player_position = doorSP.position
			orientation = Vector2.LEFT
		_:
			player_position = doorSP.position
			orientation = Vector2.LEFT
	stats.spawn_player(
		player, null, null, player_position, orientation)



func _on_TransitionZone_transition_triggered():
	Transition.go_to("res://Levels/0.0 Cave/PuzzleCave2.tscn", "secret")
