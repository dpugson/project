extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var topSP = $topSP
onready var bottomSP = $bottomSP
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var cutscene_animation = $CutsceneAnimation
onready var robot_remote_transform = $YSort/RemoteTransform2D
onready var camera = $PuppyCamera

enum {
	PILLOW_MODE,
	CRAZY_MODE
}

var ROBOT_PITCH = 2
var ROBOT_SPEECH_SPEED = 0.05

var mode = PILLOW_MODE
func _ready():
	# TODO delete
	stats.world_state["CYBERNETICALLY_ENHANCED_TURBO"] = true
	var player_position = bottomSP.global_position
	var orientation = Vector2.UP
	Jukebox.play_song("res://tunes/lab/background_science.wav")
	match stats.spawn_metadata:
		"bottom":
			player_position = bottomSP.global_position
			orientation = Vector2.UP
		"top":
			player_position = topSP.global_position
			orientation = Vector2.DOWN
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)

func create_and_start_timer(time, func_name):
	var timer = Timer.new()
	self.add_child(timer)
	timer.wait_time = time
	timer.connect("timeout", self, func_name, [timer])
	timer.one_shot = true
	timer.start()

func give_robot_focus():
	if player.remote_transform != null:
		camera.smoothing_speed = 1
		player.remote_transform.queue_free()
	robot_remote_transform.remote_path = "../../PuppyCamera"

func _on_bottomTZ_transition_triggered():
	Transition.go_to("res://Levels/1.0 - Lab/labhallway.tscn", "lab")
