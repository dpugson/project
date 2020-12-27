extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var topSP = $topSP
onready var bottomSP = $bottomSP
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var zoom_animation = $ZoomPanels/zoomanimation
onready var doggo_animation = $AnimationPlayer
onready var lever = $YSort/Lever/lever
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

func handle_zoom(pillow_offset, ooc_offset):
	match mode:
		PILLOW_MODE:
			if !doggo_animation.is_playing():
				doggo_animation.assigned_animation = "doggo_default_run"
				doggo_animation.advance(pillow_offset)
				doggo_animation.play("doggo_default_run")
		CRAZY_MODE:
			give_robot_focus()
			if !doggo_animation.is_playing():
				doggo_animation.assigned_animation = "out_of_control"
				doggo_animation.advance(ooc_offset)
				doggo_animation.play("out_of_control")

func _on_ZoomPanel_BR_activated():
	handle_zoom(0.6, 0.6)

func _on_ZoomPanel_UR_activated():
	handle_zoom(1.2, 1.2)

func _on_ZoomPanel_UL_activated():
	handle_zoom(1.8, 1.8)

func _on_ZoomPanel_ML_activated():
	handle_zoom(2.2, 2.0)

func _on_ZoomPanel_M_activated():
	if !doggo_animation.is_playing():
		doggo_animation.assigned_animation = "doggo_default_run"
		doggo_animation.advance(2.6)
		doggo_animation.play("doggo_default_run")

func _on_ZoomPanel_BL_activated():
	handle_zoom(0.0, 0.0)

func _on_Lever_pulled(side):
	match side:
		0:
			mode = PILLOW_MODE
			zoom_animation.play("go_back")
		1:
			mode = CRAZY_MODE
			zoom_animation.play("go_to_alternate")

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

func out_of_control():
	doggo_animation.play("really_out_of_control")
	create_and_start_timer(2, "robot_appear_and_remark")

func robot_appear_and_remark(timer):
	cutscene_animation.play("robot_appear")
	timer.queue_free()

func robot_say_what_was_that():
	var dialogue = {
		"begin" : [
			"TEXT", "What was that noise-", ROBOT_SPEECH_SPEED, 
			null, null, null, ROBOT_PITCH
		],
	}
	DialogueHelper.showDialogue(self, dialogue, false, [self, "speed_up"])

func speed_up():
	doggo_animation.playback_speed = 2
	create_and_start_timer(2, "OHMYGOD")

func OHMYGOD(timer):
	timer.queue_free()
	var dialogue = {
		"begin" : [
			"TEXT", "OH MY GOSH", ROBOT_SPEECH_SPEED, 
			"2", null, null, ROBOT_PITCH
		],
		"2" : [
			"TEXT", "PUPPY!?!?!?", ROBOT_SPEECH_SPEED, 
			"3", null, null, ROBOT_PITCH
		],
		"3" : [
			"TEXT", "THIS IS NOT SAFE!!!", ROBOT_SPEECH_SPEED, 
			"4", null, null, ROBOT_PITCH
		],
		"4" : [
			"TEXT", "OH DEAR OH DEAR...", ROBOT_SPEECH_SPEED, 
			null, null, null, ROBOT_PITCH
		],
	}
	DialogueHelper.showDialogue(self, dialogue, false, [self, "intervene"])

func intervene():
	cutscene_animation.play("intervene")
 
func ok_ok_ok():
	var dialogue = {
		"begin" : [
			"TEXT", "OK OK OK, I can do this...", ROBOT_SPEECH_SPEED, 
			"2", null, null, ROBOT_PITCH
		],
		"2" : [
			"TEXT", "Just gotta take a deep breath and...", ROBOT_SPEECH_SPEED, 
			null, null, null, ROBOT_PITCH
		],
	}
	DialogueHelper.showDialogue(self, dialogue, false, [self, "intervene2"])

func intervene2():
	cutscene_animation.play("intervene2")

func intervention_over():
	player.cutscene_mode = true
	doggo_animation.play("stopped")

func gotcha():
	var dialogue = {
		"begin" : [
			"TEXT", "OK... Leaving the puppy alone was a bad idea.....", ROBOT_SPEECH_SPEED, 
			"2", null, null, ROBOT_PITCH
		],
		"2" : [
			"TEXT", "I'll just move the puppy to a safer room...\nyes, yes...", ROBOT_SPEECH_SPEED, 
			null, null, null, ROBOT_PITCH
		],
	}
	DialogueHelper.showDialogue(self, dialogue, false, [self, "on_to_next_room"])

func on_to_next_room():
	cutscene_animation.play("on_to_next_room")

func go_to_next_room():
	Transition.go_to("res://Levels/1.0 - Lab/labpuzzleroom2.tscn", "cutscene")

func _on_bottomTZ_transition_triggered():
	Transition.go_to("res://Levels/1.0 - Lab/labhallway.tscn", "lab")
