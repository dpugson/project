extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var doorSP = $DoorSP
onready var animation = $AnimationPlayer

onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

var ROBOT_PITCH = 2
var ROBOT_SPEECH_SPEED = 0.05

func _ready():
	var player_position = Vector2.ZERO
	var orientation = Vector2.UP
	stats.spawn_metadata = "emerge_cutscene"
	match stats.spawn_metadata:
		"door":
			Jukebox.play_song("res://tunes/lab/background_science.wav")
			player_position = doorSP.position
			orientation = Vector2.UP
		"emerge_cutscene":
			Jukebox.fade_out()
			player.visible = false
			player.cutscene_mode = true
			player.queue_free()
			animation.play("walk_in")
			return
		_:
			Jukebox.play_song("res://tunes/lab/background_science.wav")
			player_position = doorSP.position
			orientation = Vector2.UP
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)

func _on_DoorTZ_transition_triggered():
	Transition.go_to("res://Levels/1.0 - Lab/labhallway.tscn", "break_room")

var cozylog = {
	"begin" : [
		"TEXT", "Here you go, puppy.", ROBOT_SPEECH_SPEED, 
		"2", null, null, ROBOT_PITCH
	],
	"2" : [
		"TEXT", "A nice and cozy place for you to dry off.", ROBOT_SPEECH_SPEED, 
		"3", null, null, ROBOT_PITCH
	],
	"3" : [
		"TEXT", "Here- let me give you a towel from my towel storage compartment.", ROBOT_SPEECH_SPEED, 
		"4", null, null, ROBOT_PITCH
	],
	"4" : [
		"TEXT", "YOU HAVE BEEN EN-TOWELED.", ROBOT_SPEECH_SPEED, 
		null, null, null, null
	],
}

func nice_n_cozy():
	DialogueHelper.showDialogue(self, cozylog, false, [self, "back_off"])

func back_off():
	animation.play("back_off")

var there_we_go_log = {
	"begin" : [
		"TEXT", "Perfect! Snug as a bug in a rug.", ROBOT_SPEECH_SPEED, 
		null, null, null, ROBOT_PITCH
	],
}

func there_we_go():
	DialogueHelper.showDialogue(self, there_we_go_log, false, [self, "sit_down"])

func sit_down():
	animation.play("sit_down")

var talk_lots_log = {
	"begin" : [
		"TEXT", "So tell me, puppy... How did you end up in such a soggy situation?", ROBOT_SPEECH_SPEED, 
		[["*sniffle*", "3"], ["*snuffle*", "3"],], null, null, ROBOT_PITCH
	],
	"3" : [
		"TEXT", "You what!? Come again?", ROBOT_SPEECH_SPEED, 
		null, null, null, ROBOT_PITCH
	],
}

func talk_lots():
	DialogueHelper.showDialogue(self, talk_lots_log, false, [self, "leave_room"])

func leave_room():
	pass

