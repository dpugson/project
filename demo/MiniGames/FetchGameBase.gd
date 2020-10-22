extends Node2D

export(bool) var auto_start = true

onready var ysort = $YSort
onready var vp = $VP
onready var player = $YSort/FetchGamePlayer
onready var timer = $Timer

const RADIUS = 2500

var FetchObstacle = preload("res://MiniGames/FetchGameObstacle.tscn")

var round_info = {
	"obstacle_map": {
		"*" : { "scene": preload("res://MiniGames/battles/StalagmiteObstacle.tscn"),
				"end_scale" : 10 }
	},
	"rounds": [
		["__*___", 3],
		["______", 1],
		["**____", 1],
		["_**___", 1],
		["__**__", 4],
		["**__**", 5],
	]
}

var round_index = 0

signal round_over

func _ready():
	if auto_start:
		start()

func start():
	round_index = 0
	timer.wait_time = 1
	timer.start()

func _on_Timer_timeout():
	var rounds = round_info["rounds"]
	if round_index == rounds.size():
		emit_signal("round_over")
		return
	else:
		var curr = rounds[round_index][0]
		var wait_after = rounds[round_index][1]
		var obstacle_map = round_info["obstacle_map"]
		var length = len(curr)
		var offset = (RADIUS * 2) / length
		for i in range(length):
			var c = curr[i]
			var end_vector = Vector2(-RADIUS + (i * offset), 2000)
			var obstacle = obstacle_map.get(c, null)
			if obstacle != null:
				var scene = obstacle["scene"]
				var end_scale = obstacle["end_scale"]
				spawn_obstacle(scene, end_vector, end_scale)
		timer.wait_time = wait_after
		timer.start()
	round_index += 1
	
func spawn_obstacle(scene, end_vector, end_scale):
	var fetch_obstacle = FetchObstacle.instance()
	fetch_obstacle.init(scene)
	ysort.add_child(fetch_obstacle)
	fetch_obstacle.set_origin(vp.position)
	fetch_obstacle.end_scale = Vector2(end_scale, end_scale)
	fetch_obstacle.set_end(vp.position + end_vector)
	fetch_obstacle.play()

