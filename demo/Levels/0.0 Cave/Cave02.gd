extends Node2D

onready var spawnPoint = $SpawnPoint
onready var stats = PlayerStats
onready var player = $YSort/player

# Called when the node enters the scene tree for the first time.
func _ready():
	var player_position = Vector2.ZERO
	if stats.player_position != null:
		player_position = stats.player_position_get()
	else:
		player_position = spawnPoint.position
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, Vector2.UP)
 
