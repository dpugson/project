extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var topSP = $TopSP
onready var bottomSP = $BottomSP
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

func _ready():
	#stats.spawn_metadata = "cutscene"
	var player_position = bottomSP.global_position
	var orientation = Vector2.RIGHT
	#Jukebox.play_song("res://tunes/lab/background_science.wav")
	match stats.spawn_metadata:
		"bottom":
			player_position = bottomSP.global_position
			orientation = Vector2.RIGHT
		"top":
			player_position = topSP.global_position
			orientation = Vector2.DOWN
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)


func _on_BottomTZ_transition_triggered():
	Transition.go_to("res://Levels/2.0 - Forest/OutsideLab_02.tscn", "right")



func _on_TopTZ_transition_triggered():
	Transition.go_to("res://Levels/2.0 - Forest/Town.tscn", "bottom")

