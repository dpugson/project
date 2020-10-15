extends Node2D

onready var ysort = $YSort
onready var vp = $VP

const RADIUS = 1200
const SCALE = 2.2

var FetchObstacle = preload("res://MiniGames/FetchGameObstacle.tscn")

func _onread():
	pass
	
func spawn_obstacle():
	var obstacle = FetchObstacle.instance()
	ysort.add_child(obstacle)
	obstacle.set_origin(vp.position)
	obstacle.end_scale = Vector2(SCALE, SCALE)
	var end_vector = Vector2(rand_range(-RADIUS, RADIUS), 2000)
	obstacle.set_end(vp.position + end_vector)
	obstacle.play()


func _on_Timer_timeout():
	spawn_obstacle()
