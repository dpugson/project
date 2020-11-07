extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var transition = Transition

onready var entrance_sp = $EntrySP
onready var stairs_sp = $StairsSP

func _ready():
	var player_position = Vector2.ZERO
	var player_orientation = Vector2.DOWN
	match stats.spawn_metadata:
		"entrance":
			player_position = entrance_sp.position
			player_orientation = Vector2.UP
		"stairs":
			player_position = stairs_sp.position
			player_orientation = Vector2.DOWN
		_:
			player_position = entrance_sp.position
			player_orientation = Vector2.UP
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, player_orientation)
