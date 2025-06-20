extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var tween = $Tween

onready var bottomSP = $BottomSP

func _ready():
	var player_position = player.position
	var orientation = Vector2.DOWN
	Jukebox.play_song("res://tunes/forest/starswaltz_slow.wav")
	match stats.spawn_metadata:
		"bottom":
			player_position = bottomSP.position
			orientation = Vector2.UP
		_:
			player_position = bottomSP.position
			orientation = Vector2.UP
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)


func _on_PlayerDetectionZone_body_entered(_body):
	tween.stop_all()
	if player.remote_transform != null:
		tween.interpolate_property(player.remote_transform, "position",
							player.remote_transform.position,
							Vector2(0, -480), 1.6, Tween.TRANS_CUBIC)
		tween.start()

func _on_PlayerDetectionZone_body_exited(_body):
	if not tween.is_inside_tree():
		return
	tween.stop_all()
	if player.remote_transform != null:
		tween.interpolate_property(player.remote_transform, "position",
							player.remote_transform.position,
							Vector2(0, 0), 1.6, Tween.TRANS_CUBIC)
		tween.start()
		


func _on_BottomTZ_transition_triggered():
	Transition.go_to("res://Levels/2.0 - Forest/Town.tscn", "gate") 
