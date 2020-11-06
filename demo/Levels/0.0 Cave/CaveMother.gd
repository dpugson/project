extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var transition = Transition
onready var bottomSpawnPoint = $BottomSpawnPoint
onready var topSpawnPoint = $TopSpawnPoint
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var camera = $PuppyCamera
onready var timer = $Timer

func _ready():
	Jukebox.play_song("res://tunes/cave/fallen.wav")
	var player_position = Vector2.ZERO
	var orientation = Vector2.DOWN
	match stats.spawn_metadata:
		"left":
			player_position = bottomSpawnPoint.position
			orientation = Vector2.RIGHT
		"right":
			player_position = topSpawnPoint.position
			orientation = Vector2.LEFT
		_:
			player_position = bottomSpawnPoint.position
			orientation = Vector2.RIGHT
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)
		

var orig_remote_path = null
var orig_camera_position = null
func _on_Sign_done():
	player.cutscene_mode = true
	var tween = Tween.new()
	self.add_child(tween)
	orig_remote_path = player.remote_transform.remote_path
	print(orig_remote_path)
	orig_camera_position = camera.position
	player.remote_transform.remote_path = ""
	var new_position: Vector2 = camera.position
	new_position.y = new_position.y - 600
	tween.interpolate_property(
		camera,
		"position",
		camera.position,
		new_position,
		2
	)
	tween.connect("tween_completed", self, "tween_done", [tween])
	tween.start()

func tween_done(_a, _b, tween):
	tween.queue_free()
	timer.wait_time = 2
	timer.start()
	
func _on_Timer_timeout():
	var tween = Tween.new()
	self.add_child(tween)
	tween.interpolate_property(
		camera,
		"position",
		camera.position,
		orig_camera_position,
		2
	)
	tween.connect("tween_completed", self, "tween_done2", [tween])
	tween.start()

func tween_done2(_a, _b, tween):
	player.cutscene_mode = false
	tween.queue_free()
	player.remote_transform.remote_path = orig_remote_path


func _on_LeftEntrance_transition_triggered():
	Transition.go_to("res://Levels/0.0 Cave/CaveBridge.tscn", "right")

func _on_RightEntrance_transition_triggered():
	Transition.go_to("res://Levels/0.0 Cave/LongCave.tscn", "bottom")
