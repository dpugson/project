extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var transition = Transition
onready var bottomSpawnPoint = $BottomSpawnPoint
onready var topSpawnPoint = $TopSpawnPoint
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

func _ready():
	Jukebox.play_song("res://tunes/cave/fallen.wav")
	var player_position = Vector2.ZERO
	var orientation = Vector2.DOWN
	match stats.spawn_metadata:
		"bottom":
			player_position = bottomSpawnPoint.position
			orientation = Vector2.UP
		"top":
			player_position = topSpawnPoint.position
			orientation = Vector2.DOWN
		_:
			player_position = bottomSpawnPoint.position
			orientation = Vector2.UP
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)

func _on_UpperTZ_transition_triggered():
	Transition.go_to("res://Levels/0.0 Cave/PuzzleCave4.tscn", "bottom")

func _on_LowerTZ_transition_triggered():
	Transition.go_to("res://Levels/21.0 Train/SunflowerRoad.tscn", "top")
