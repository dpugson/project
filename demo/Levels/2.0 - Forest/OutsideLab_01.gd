extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var labSP = $LabSP
onready var tangleSP = $TangleSP
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var camera = $PuppyCamera

func _ready():
	var player_position = labSP.global_position
	var orientation = Vector2.RIGHT
	Jukebox.play_song("res://tunes/forest/forest_theme_lofi.wav")
	match stats.spawn_metadata:
		"lab":
			player_position = labSP.global_position
			orientation = Vector2.UP
		"tangle":
			player_position = tangleSP.global_position
			orientation = Vector2.DOWN
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)


func _on_PuzzleHouseTZ_transition_triggered():
	Transition.go_to("res://Levels/1.0 - Lab/GiftShop.tscn", "top")
