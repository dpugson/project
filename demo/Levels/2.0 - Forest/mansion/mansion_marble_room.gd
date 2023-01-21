extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var leftSP = $leftSP
onready var rightSP = $rightSP
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var camera = $PuppyCamera
onready var tween = $Tween

func _ready():
	var player_position = leftSP.global_position
	var orientation = Vector2.UP
	Jukebox.play_song("res://tunes/starsong.wav")
	match stats.spawn_metadata:
		"left":
			player_position = leftSP.global_position
			orientation = Vector2.UP
		"right":
			player_position = rightSP.global_position
			orientation = Vector2.RIGHT
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)


func _on_rightTZ_transition_triggered():
	pass # Replace with function body.

func _on_leftTZ_transition_triggered():
	pass # Replace with function body.

func _on_PlayerDetectionZone_body_entered(_body):
	tween.stop_all()
	if player.remote_transform != null:
		tween.interpolate_property(player.remote_transform, "position",
							player.remote_transform.position,
							Vector2(0, -280), 1.6, Tween.TRANS_CUBIC)
		tween.start()

func _on_PlayerDetectionZone_body_exited(_body):
	tween.stop_all()
	if player.remote_transform != null:
		tween.interpolate_property(player.remote_transform, "position",
							player.remote_transform.position,
							Vector2(0, 0), 1.6, Tween.TRANS_CUBIC)
		tween.start()
