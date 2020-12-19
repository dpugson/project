extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var topSP = $topSP
onready var bottomSP = $bottomSP
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var cutscene_animation = $CutsceneAnimation
onready var robot_remote_transform = $YSort/RemoteTransform2D
onready var camera = $PuppyCamera

const EffectHelper = preload("res://effects/EffectHelper.gd")
const StarEffect  = preload("res://Levels/1.0 - Lab/StarEffect.tscn")

enum {
	PILLOW_MODE,
	CRAZY_MODE
}

var ROBOT_PITCH = 2
var ROBOT_SPEECH_SPEED = 0.05

var mode = PILLOW_MODE
func _ready():
	# TODO delete
	#stats.spawn_metadata = "cutscene"
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
		"cutscene":
			player.cutscene_mode = true
			player.visible = false
			cutscene_animation.play("dropoff")
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

func dropoff():
	var dialogue = {
		"begin" : [
			"TEXT", "Alright doggy...", ROBOT_SPEECH_SPEED, 
			"begin2", null, null, ROBOT_PITCH
		],
		"begin2" : [
			"TEXT", "I don't know how you got into that last room,\nbut this one should be much safer!", ROBOT_SPEECH_SPEED, 
			"2", null, null, ROBOT_PITCH
		],
		"2" : [
			"TEXT", "And hopefully fun!!!\nThis is where we do button research.", ROBOT_SPEECH_SPEED, 
			"3", null, null, ROBOT_PITCH
		],
		"3" : [
			"TEXT", "I am sorry I have to leave you again, doggy...", ROBOT_SPEECH_SPEED, 
			"4", null, null, ROBOT_PITCH
		],
		"4" : [
			"TEXT", "But I have to get some work done!\nThis is the duty of the SCIENTIST!", ROBOT_SPEECH_SPEED, 
			null, null, null, ROBOT_PITCH
		],
	}
	DialogueHelper.showDialogue(self, dialogue, false, [self, "robot_leave"])

func robot_leave():
	cutscene_animation.play("robot_leave")

func cutscene_over():
	player.cutscene_mode = false

func _on_bottomTZ_transition_triggered():
	Transition.go_to("res://Levels/1.0 - Lab/labhallway.tscn", "lab")

var num_stars_active = 0
func _on_StarButton_activated(star):
	print(num_stars_active, "++")
	num_stars_active += 1
	if num_stars_active >= 9:
		EffectHelper.place_effect(star, StarEffect)

func _on_StarButton_deactivated():
	num_stars_active -= 1
	print(num_stars_active, "--")

