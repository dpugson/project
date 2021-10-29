extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var topSP = $TopSP
onready var bottomSP = $BottomSP
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var tween = $Tween

onready var stage = $YSort/Stage
onready var lightspot = $LightSpot
onready var maxlightspot = $MaxLightSpotDistance
onready var max_distance = abs(lightspot.global_position.y
	- maxlightspot.global_position.y)

func _physics_process(_delta):
	var distance = player.global_position.y - lightspot.global_position.y
	var multiplier = distance / max_distance
	var lighting_value = clamp(1 * multiplier, .4, .8)
	stage.modulate = Color(lighting_value, lighting_value, lighting_value)

func _ready():
	var player_position = player.position
	var orientation = Vector2.DOWN
	var spawn_player = true
	Jukebox.play_song("res://tunes/forest/starswaltz_slow.wav")
	match stats.spawn_metadata:
		"door":
			player_position = topSP.position
			orientation = Vector2.RIGHT
		_:
			player_position = bottomSP.position
			orientation = Vector2.UP
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
