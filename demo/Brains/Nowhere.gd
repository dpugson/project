extends Node2D

onready var player = $player

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerStats.spawn_player(
		player, null, 
		"../../PuppyCamera",
		$SpawnPoint.position,
		Vector2.DOWN)
