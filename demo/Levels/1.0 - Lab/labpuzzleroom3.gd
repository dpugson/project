extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var topSP = $topSP
onready var bottomSP = $bottomSP
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var cutscene_animation = $CutsceneAnimation
onready var robot_remote_transform = $YSort/robot/RemoteTransform2D
onready var camera = $PuppyCamera
onready var robot = $YSort/robot

const EffectHelper = preload("res://effects/EffectHelper.gd")

var ROBOT_PITCH = 2
var ROBOT_SPEECH_SPEED = 0.05

func _ready():
	var player_position = bottomSP.global_position
	var orientation = Vector2.UP
	Jukebox.play_song("res://tunes/lab/background_science.wav")
	match stats.spawn_metadata:
		"bottom":
			player_position = bottomSP.global_position
			orientation = Vector2.UP
		"top":
			player_position = topSP.global_position
			orientation = Vector2.DOWN
		"cutscene":
			player.cutscene_mode = true
			player.visible = false
			cutscene_animation.play("dropoff")
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)

func dropoff():
	pass
