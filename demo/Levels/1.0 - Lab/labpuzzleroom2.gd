extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var topSP = $topSP
onready var bottomSP = $bottomSP
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var cutscene_animation = $CutsceneAnimation
onready var robot_remote_transform = $YSort/robot/RemoteTransform2D
onready var camera = $PuppyCamera
onready var stars = $stars
onready var starbuttons = $starbuttons
onready var robot = $YSort/robot
onready var cutscene_puppy_spot = $CutscenePuppySpot
onready var leave_spot = $LeaveSpot

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
	print("HI!")
	robot_remote_transform.remote_path = "../../../PuppyCamera"

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

var num_times_activated = 0
var num_stars_active = 0
func _on_StarButton_activated(_star):
	num_stars_active += 1
	if num_stars_active >= 9:
		num_stars_active = 0
		num_times_activated += 1
		if num_times_activated == 1:
			give_robot_focus()
			cutscene_animation.play("star_win2")
		else:
			cutscene_animation.play("star_win")

func _on_StarButton_deactivated():
	num_stars_active -= 1

func launch_effects():
	for child in stars.get_children():
		child.start()

func deactivate_buttons():
	for child in starbuttons.get_children():
		child.deactivate()

func turn_robot_right():
	robot.animation = "right"

func free_me(_a, _b, tween):
	tween.queue_free()

func OMIGOD():
	player.cutscene_mode = true
	var dialogue = {
		"begin" : [
			"TEXT", "What was that-", ROBOT_SPEECH_SPEED, 
			"begin2", null, null, ROBOT_PITCH
		],
		"begin2" : [
			"TEXT", "WHAT THE-", ROBOT_SPEECH_SPEED, 
			"2",  [self, "turn_robot_right"], null, ROBOT_PITCH
		],
		"2" : [
			"TEXT", "FIRE!!!!!", ROBOT_SPEECH_SPEED, 
			null, null, null, ROBOT_PITCH
		]
	}
	DialogueHelper.showDialogue(self, dialogue, false, [self, "leave_n_comeback"])

func leave_n_comeback():
	cutscene_animation.play("leave_n_comeback")

func go_to_grab_puppy():
	var tween = Tween.new()
	self.add_child(tween)
	var dest = player.global_position
	dest.y -= 150
	tween.interpolate_property(
		robot,
		"global_position",
		robot.global_position,
		dest,
		1.6
	)
	robot.playing = true
	robot.animation = "down"
	tween.connect("tween_completed", self, "grab_puppy", [tween])
	tween.start()

func grab_puppy(_a, _b, tween):
	tween.queue_free()
	robot.animation = "dogdown"
	player.visible = false
	var dialogue = {
		"begin" : [
			"TEXT", "OK! I learned my lesson!", ROBOT_SPEECH_SPEED, 
			"begin2", null, null, ROBOT_PITCH
		],
		"begin2" : [
			"TEXT", "I am not going to leave you alone this time.", ROBOT_SPEECH_SPEED, 
			null, null, null, ROBOT_PITCH
		],
	}
	DialogueHelper.showDialogue(self, dialogue, false, [self, "head_out"])
	
func head_out():
	var tween = Tween.new()
	self.add_child(tween)
	var dest = leave_spot.global_position
	tween.interpolate_property(
		robot,
		"global_position",
		robot.global_position,
		dest,
		1.6
	)
	robot.playing = true
	robot.animation = "dogup"
	tween.connect("tween_completed", self, "leave", [tween])
	tween.start()

func leave(_a, _b, tween):
	tween.queue_free()
