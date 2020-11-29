extends Node2D

export(bool) var auto_start = true

onready var ysort = $YSort
onready var vp = $VP
onready var player = $YSort/FetchGamePlayer
onready var timer = $Timer
onready var tween = $Tween
onready var animation = $AnimationPlayer
onready var pacer_timer = $PacerTimer

onready var horizon = $horizon
onready var edge = $edge
onready var left_endpoint = $left_endpoint
onready var right_endpoint = $right_endpoint
onready var ball = $YSort/ball
onready var ball2 = $DogWithBallFront/ball2

onready var start_label = $Label

const RADIUS = 2500

const win_position = Vector2(856.628, 972.276)

var FetchObstacle = preload("res://MiniGames/FetchGameObstacle.tscn")

var round_info = {
	"obstacle_map": {
		"*" : { "scene": preload("res://MiniGames/battles/StalagmiteObstacle.tscn"),
				"end_scale" : 10 },
	},
	"rounds": [
		["__*___", 3],
		["______", 1],
		["**____", 1],
		["_**___", 1],
		["__**__", 1],
		["____**", 4],
		["_****_", 3],
		["**__**", 5],
	],
}

var round_index = 0

signal round_over

func _ready():
	edge.points[0].x = left_endpoint.position.x
	edge.points[0].y = left_endpoint.position.y
	edge.points[1].x = vp.position.x
	edge.points[1].y = vp.position.y
	edge.points[2].x = right_endpoint.position.x
	edge.points[2].y = right_endpoint.position.y
	
	horizon.points[0].x = -RADIUS
	horizon.points[0].y = vp.position.y
	horizon.points[1].x = RADIUS
	horizon.points[1].y = vp.position.y
	
	if auto_start:
		start()

func set_ball_texture(new_texture, is_obj=false):
	if new_texture == null:
		return
	if is_obj:
		ball.texture = null
		ball2.texture = null
		ball.add_child(new_texture.instance())
		ball2.add_child((new_texture.instance()))
	else:
		ball.texture = new_texture
		ball2.texture = new_texture

func start():
	start_label.text = round_info.get("start_text", "GO FETCH!")
	animation.play("intro")

func intro_complete():
	round_index = 0
	timer.wait_time = 1
	timer.start()

func start_end_sequence():
	player.cutscene_mode = true
	tween.interpolate_property(
		player,
		"position",
		player.position,
		win_position,
		1
	)
	tween.connect("tween_completed", self, "continue_end_sequence")
	tween.start()

func continue_end_sequence(_a, _b):
	animation.play("grab_ball")
	
func complete_end_sequence():
	print("COMPLETE")
	emit_signal("round_over")

func _on_Timer_timeout():
	var rounds = round_info["rounds"]
	if round_index == rounds.size():
		start_end_sequence()
		return
	else:
		var curr = rounds[round_index][0]
		var wait_after = rounds[round_index][1]
		if round_index == rounds.size() - 1:
			wait_after += 2
		var obstacle_map = round_info["obstacle_map"]
		var length = len(curr)
		var offset = (RADIUS * 2) / length
		for i in range(length):
			var c = curr[i]
			var end_vector = Vector2(-RADIUS + ((i + 0.4) * offset), 2000)
			var obstacle = obstacle_map.get(c, null)
			if obstacle != null:
				var scene = obstacle["scene"]
				var end_scale = obstacle["end_scale"]
				spawn_obstacle(ysort, scene, end_vector, end_scale)
		timer.wait_time = wait_after
		timer.start()
	round_index += 1
	
func spawn_obstacle(parent, scene, end_vector, end_scale):
	var fetch_obstacle = FetchObstacle.instance()
	fetch_obstacle.init(scene)
	parent.add_child(fetch_obstacle)
	fetch_obstacle.set_origin(vp.position)
	if end_scale == null:
		fetch_obstacle.end_scale = null
	else:
		fetch_obstacle.end_scale = Vector2(end_scale, end_scale)
	fetch_obstacle.set_end(vp.position + end_vector)
	fetch_obstacle.play()

onready var pacer_parent = $PositionSameAsYsort
func _on_PacerTimer_timeout():
	var scene = preload("res://MiniGames/obstacles/HorizontalLine.tscn")
	var end_scale = null
	spawn_obstacle(pacer_parent, scene, Vector2(0, 2000), end_scale)

func _on_FetchGamePlayer_game_over():
	Jukebox.stop()
	timer.stop()
	pacer_timer.stop()
	player.cutscene_mode = true
	var game_over_timer = Timer.new()
	add_child(game_over_timer)
	game_over_timer.wait_time = 1
	game_over_timer.connect("timeout", self, "game_over")
	game_over_timer.start()

func game_over():
	Transition.go_to("res://Brains/GameOver.tscn")
