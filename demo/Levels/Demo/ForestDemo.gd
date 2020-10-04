extends Node2D

onready var spawnPoint = $SpawnPoint
onready var ysorted = $YSortedThings
onready var stats = PlayerStats


func _ready():
	stats.spawn_player(
		null,
		ysorted,
		"../../../PuppyCamera", 
		spawnPoint.position,
		Vector2.RIGHT
	)
