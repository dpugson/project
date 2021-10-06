extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var doorSpawnPoint = $DoorSP
onready var animation = $AnimationPlayer
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

var ROBOT_PITCH = 2
var ROBOT_SPEECH_SPEED = 0.05

func _ready():
	var player_position = player.position
	var orientation = Vector2.DOWN
	var spawn_player = true
	match stats.spawn_metadata:
		"door":
			Jukebox.play_song("res://tunes/lab/background_science.wav")
			player_position = doorSpawnPoint.position
			orientation = Vector2.UP
			animation.play("default")
		"toilet":
			# TODO
#			player_position = toiletSpawnPoint.position
#			orientation = Vector2.DOWN
			pass
		"emerge_cutscene":
			Jukebox.play_song("res://tunes/lab/sleepypuppy.wav")
			player.queue_free()
			spawn_player = false
			animation.play("cutscene")
		_:
			Jukebox.play_song("res://tunes/lab/background_science.wav")
			player_position = doorSpawnPoint.position
			orientation = Vector2.UP
			animation.play("default")
	if spawn_player:
		stats.spawn_player(
			player, null, 
			"../../../PuppyCamera", player_position, orientation)


var cutscene_dialogue_1 = {
	"begin" : [
		"TEXT", "Sigh...", ROBOT_SPEECH_SPEED, 
		"2", null, null, ROBOT_PITCH
	],
	"2" : [
		"TEXT", "Another year over...", ROBOT_SPEECH_SPEED, 
		"3", null, null, ROBOT_PITCH
	],
	"3" : [
		"TEXT", "And my thesis still isn't any closer to being finished...", ROBOT_SPEECH_SPEED, 
		"4", null, null, ROBOT_PITCH
	],
	"4" : [
		"TEXT", "Is this it? Is this what I've amounted to?", ROBOT_SPEECH_SPEED, 
		"42", null, null, ROBOT_PITCH
	],
	"42" : [
		"TEXT", "Am I just a washed up bucket of bolts?", ROBOT_SPEECH_SPEED, 
		"5", null, null, ROBOT_PITCH
	],
	"5" : [
		"TEXT", "Maybe I should leave town.", ROBOT_SPEECH_SPEED, 
		"6", null, null, ROBOT_PITCH
	],
	"6" : [
		"TEXT", "Change my name. Grow my hair out. Make a fresh start.", ROBOT_SPEECH_SPEED, 
		"7", null, null, ROBOT_PITCH
	],
	"7" : [
		"TEXT", "Sell homemade jam in a farmer's market.", ROBOT_SPEECH_SPEED, 
		null, null, null, ROBOT_PITCH
	],
}

func start_cutscene():
	DialogueHelper.showDialogue(self, cutscene_dialogue_1, false, [self, "toilet_opens"])

func toilet_opens():
	animation.play("toilet_open")

var what_was_that = {
	"begin" : [
		"TEXT", "Huh?", ROBOT_SPEECH_SPEED, 
		"2", null, null, ROBOT_PITCH
	],
	"2" : [
		"TEXT", "What was that?", ROBOT_SPEECH_SPEED, 
		null, null, null, ROBOT_PITCH
	],
}

func respond_to_open_toilet():
	DialogueHelper.showDialogue(self, what_was_that, false, [self, "water_effects"])

func water_effects():
	animation.play("water_effects")

var huh = {
	"begin" : [
		"TEXT", "Oh no!", ROBOT_SPEECH_SPEED, 
		null, null, null, ROBOT_PITCH
	],
}

func respond_to_water():
	DialogueHelper.showDialogue(self, huh, false, [self, "more_water"])

func more_water():
	animation.play("more_water")

var oh_no = {
	"begin" : [
		"TEXT", "OH NO!!!!!!", ROBOT_SPEECH_SPEED, 
		null, null, null, ROBOT_PITCH
	],
}

func say_oh_no():
	DialogueHelper.showDialogue(self, oh_no, false, [self, "panic"])

func panic():
	animation.play("panic")
	
var ohnox3 = {
	"begin" : [
		"TEXT", "Oh no oh no oh no oh no!!!!!", ROBOT_SPEECH_SPEED, 
		null, null, null, ROBOT_PITCH
	],
}

func say_oh_no_many_times():
	DialogueHelper.showDialogue(self, ohnox3, false, [self, "puppy_emerges"])

func puppy_emerges():
	animation.play("puppy_emerges")

var hello_dialogue = {
	"begin" : [
		"TEXT", "Oh my goodness!!!!", ROBOT_SPEECH_SPEED, 
		"2", null, null, ROBOT_PITCH
	],
	"2" : [
		"TEXT", "A doggy in the toilet???", ROBOT_SPEECH_SPEED, 
		"3", null, null, ROBOT_PITCH
	],
	"3" : [
		"TEXT", "CALCULATING, CALCULATING... This isn't right!!!", ROBOT_SPEECH_SPEED, 
		"4", null, null, ROBOT_PITCH
	],
	"4" : [
		"TEXT", "That puppy needs assistance!!!", ROBOT_SPEECH_SPEED, 
		null, null, null, ROBOT_PITCH
	],
}

func hello_puppy():
	DialogueHelper.showDialogue(self, hello_dialogue, false, [self, "grab_puppy"])

func grab_puppy():
	animation.play("grab_puppy")

var soggy_puppy_need_help = {
	"begin" : [
		"TEXT", "My calculations indicate that this soggy puppy is\nin urgent need of drying off!", ROBOT_SPEECH_SPEED, 
		"1", null, null, ROBOT_PITCH
	],
	"1" : [
		"TEXT", "Do not worry, puppy! I will take care of you.", ROBOT_SPEECH_SPEED, 
		null, null, null, ROBOT_PITCH
	]
}

func say_soggy_puppy_need_help():
	DialogueHelper.showDialogue(self, soggy_puppy_need_help, false, [self, "leave_room"])

func leave_room():
	animation.play("leave_room")

func finish_cutscene():
	Transition.go_to("res://Levels/1.0 - Lab/labhallway.tscn", "emerge_cutscene")

func _on_DoorTZ_transition_triggered():
	Transition.go_to("res://Levels/1.0 - Lab/labhallway.tscn", "bathroom")
