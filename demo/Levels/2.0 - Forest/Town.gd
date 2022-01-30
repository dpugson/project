extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var teaShopSpawnPoint = $TeaShopSpawnPoint
onready var bottomSP = $BottomSP
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")


func _ready():
	var player_position = player.position
	var orientation = Vector2.DOWN
	var spawn_player = true
	Jukebox.play_song("res://tunes/forest/starswaltz_slow.wav")
	match stats.spawn_metadata:
		"tea":
			player_position = teaShopSpawnPoint.position
			orientation = Vector2.RIGHT
		_:
			player_position = bottomSP.position
			orientation = Vector2.UP
	if spawn_player:
		stats.spawn_player(
			player, null, 
			"../../../PuppyCamera", player_position, orientation)


func _on_BottomTZ_transition_triggered():
	Transition.go_to("res://Levels/2.0 - Forest/Tangle.tscn", "top")
