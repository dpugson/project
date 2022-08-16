extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var leftSP = $LeftSP
onready var rightSP = $RightSP
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var camera = $PuppyCamera

onready var leafs = $YSort/LEAFPILE

onready var robot = $YSort/RobotFollower
onready var hide_spot = $HideSpot

func _ready():
	if not stats.check_bool("robot_following"):
		# get rid of robot
		robot.hidden_mode()
		robot.global_position = hide_spot.global_position
	if stats.check_bool("leafs_gone"):
		leafs.queue_free()
	
	var player_position = leftSP.global_position
	var orientation = Vector2.RIGHT
	#Jukebox.play_song("res://tunes/forest/forest_theme_lofi.wav")
	#Jukebox.play_song("res://tunes/puzzletime.wav")
	match stats.spawn_metadata:
		"left":
			player_position = leftSP.global_position
			orientation = Vector2.RIGHT
		"right":
			player_position = rightSP.global_position
			orientation = Vector2.LEFT
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)


func _on_LeftTZ_transition_triggered():
	Transition.go_to("res://Levels/2.0 - Forest/OutsideLab_01.tscn", "right")

func _on_RightTZ_transition_triggered():
	Transition.go_to("res://Levels/2.0 - Forest/Tangle.tscn", "bottom")
