extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var bottomSP = $BottomSP
onready var animation = $AnimationPlayer

onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

func _ready():
	var player_position = bottomSP.position
	var orientation = Vector2.UP
	match stats.spawn_metadata:
		"bottom":
			#Jukebox.play_song("res://tunes/lab/background_science.wav")
			player_position = bottomSP.position
			orientation = Vector2.UP
		_:
			pass
			
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)


func _on_TrainSummonBox_area_entered(area):
	animation.play("arrive")
