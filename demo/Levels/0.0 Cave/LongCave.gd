extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var transition = Transition
onready var bottomSpawnPoint = $BottomSpawnPoint
onready var topSpawnPoint = $TopSpawnPoint
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var greenFriendAnimationPlayer = $GreenFriendAnimationPlayer

var secret_listener_done_count = 0

func _ready():
	Jukebox.play_song("res://tunes/cave/fallen.wav")
	var player_position = Vector2.ZERO
	var orientation = Vector2.DOWN
	match stats.spawn_metadata:
		"bottom":
			player_position = bottomSpawnPoint.position
			orientation = Vector2.RIGHT
		"top":
			player_position = topSpawnPoint.position
			orientation = Vector2.LEFT
		_:
			player_position = bottomSpawnPoint.position
			orientation = Vector2.UP
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)
		


func _on_SecretListener_done():
	secret_listener_done_count += 1
	if secret_listener_done_count >= 3:
		pass
		#greenFriendAnimationPlayer.play("GreenFriendAppear")

func _on_GreenFriendSeenBox_seen(_obj):
	pass # Replace with function body.

func _on_BottomTZ_transition_triggered():
	transition.go_to("res://Levels/0.0 Cave/CaveMother.tscn", "right")

func _on_TopTZ_transition_triggered():
	transition.go_to("res://Levels/0.0 Cave/Cave03.tscn", "upper")
