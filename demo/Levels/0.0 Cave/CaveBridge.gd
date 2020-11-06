extends Node2D


onready var stats = PlayerStats
onready var player = $YSort/player
onready var transition = Transition
onready var bottomSpawnPoint = $BottomSpawnPoint
onready var topSpawnPoint = $TopSpawnPoint
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var saveStar = $YSort/SaveStar

func _ready():
	Jukebox.play_song("res://tunes/cave/fallen.wav")
	var player_position = Vector2.ZERO
	var orientation = Vector2.DOWN
	match stats.spawn_metadata:
		"Caves - The Star Room":
			player_position = saveStar.position
		"left":
			player_position = bottomSpawnPoint.position
			orientation = Vector2.RIGHT
		"right":
			player_position = topSpawnPoint.position
			orientation = Vector2.LEFT
		_:
			player_position = bottomSpawnPoint.position
			orientation = Vector2.RIGHT
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)
		


func _on_TransitionZone_transition_triggered():
	transition.go_to("res://Levels/0.0 Cave/Cave02.tscn", "top")

func _on_TransitionZone2_transition_triggered():
	transition.go_to("res://Levels/0.0 Cave/CaveMother.tscn", "left")
