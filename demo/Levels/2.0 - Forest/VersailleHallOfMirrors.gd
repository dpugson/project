extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var shadow_player = $BGstuff/shadow_player
onready var topSP = $TopSP
onready var bottomSP = $BottomSP
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var reflect_point = $ReflectPoint
onready var tween = $Tween

func _physics_process(_delta):
	# Shadow dog
	shadow_player.global_position.x = player.global_position.x
	var reflect_distance = reflect_point.global_position.y - player.global_position.y 
	shadow_player.global_position.y = reflect_point.global_position.y + reflect_distance

func _ready():
	var player_position = player.position
	var orientation = Vector2.RIGHT
	var spawn_player = true
	Jukebox.play_song("res://tunes/forest/starswaltz_slow.wav")
	match stats.spawn_metadata:
		"bottom":
			player_position = bottomSP.position
			orientation = Vector2.RIGHT
		"right":
			player_position = topSP.position
			orientation = Vector2.LEFT
		_:
			player_position = bottomSP.position
			orientation = Vector2.RIGHT
	if spawn_player:
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
	tween.stop_all()
	if player.remote_transform != null:
		tween.interpolate_property(player.remote_transform, "position",
							player.remote_transform.position,
							Vector2(0, 0), 1.6, Tween.TRANS_CUBIC)
		tween.start()
