extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var doorSP = $DoorSP
onready var animation = $AnimationPlayer
onready var audio = $AudioStreamPlayer2D
onready var timer = $Timer
onready var blanket_dog = $YSort/blanket_dog
onready var blanket = $blanket
onready var ysort = $YSort

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
		"TEXT", "You what?", ROBOT_SPEECH_SPEED, 
		[["*Lay it all out there*", "4"]], null, null, ROBOT_PITCH
	],
	"4" : [
		"TEXT", "Wow!!! A big adventure for a little puppy.\nYou've been through a lot, already.", ROBOT_SPEECH_SPEED, 
		[["*nod*", "5"]], null, null, ROBOT_PITCH
	],
	"5" : [
		"TEXT", "Hmm... We need to get you home!\nBut it sounds like that isn't going to be easy...", ROBOT_SPEECH_SPEED, 
		[["huh???", "6"]], null, null, ROBOT_PITCH
	],
	"6" : [
		"TEXT", "You said you fell, right?", ROBOT_SPEECH_SPEED, 
		"66", null, null, ROBOT_PITCH
	],
	"66" : [
		"TEXT", "From what you've described about\nyour home, I think you must've fallen a very long ways.", ROBOT_SPEECH_SPEED, 
		"7", null, null, ROBOT_PITCH
	],
	"7" : [
		"TEXT", "In fact, I think it's likely you fell over 1000 miles.\nYou are very lucky to have survived!", ROBOT_SPEECH_SPEED, 
		"9", null, null, ROBOT_PITCH
	],
	"9" : [
		"TEXT", "But do not worry!!!\nI have an idea of who could help.", ROBOT_SPEECH_SPEED, 
		null, [self, "play_beep"], null, ROBOT_PITCH
	],
}

func talk_lots():
	DialogueHelper.showDialogue(self, talk_lots_log, false)

func play_beep():
	audio.play()
	timer.start()

func _on_Timer_timeout():
	DialogueHelper.showDialogue(self, oh_no_log, false, [self, "leave_room"])
	audio.stop()

var oh_no_log = {
	"begin" : [
		"TEXT", "OH NO!!! I have to get back to work!!!", ROBOT_SPEECH_SPEED, 
		"3", null, null, ROBOT_PITCH
	],
	"3" : [
		"TEXT", "Puppy! I'm so sorry, but I am going to have to\nleave you alone for a little while.", ROBOT_SPEECH_SPEED, 
		"4", null, null, ROBOT_PITCH
	],
	"4" : [
		"TEXT", "My five minute break is over,\nso now I am required to return to work!", ROBOT_SPEECH_SPEED, 
		"44", null, null, ROBOT_PITCH
	],
	"44" : [
		"TEXT", "Just stay cozy right here, ok?", ROBOT_SPEECH_SPEED, 
		"6", null, null, ROBOT_PITCH
	],
	"6" : [
		"TEXT", "I will be back in 23 hours and 55 minutes.", ROBOT_SPEECH_SPEED, 
		null, null, null, ROBOT_PITCH
	],
}

func leave_room():
	animation.play("leave")

func bye_bye():
	DialogueHelper.showDialogue(self, bye_log, true, [self, "leave_room4real"])

var bye_log = {
	"begin" : [
		"TEXT", "Stay cozy! I'll be right back.", ROBOT_SPEECH_SPEED, 
		null, null, null, ROBOT_PITCH
	]
}

func leave_room4real():
	animation.play("really_leave")

func cutscene_over():
	blanket_dog.paralyzed = false

func _on_blanket_dog_unwrapped():
	blanket.visible = true
	stats.spawn_player(
		null, ysort, "../../../PuppyCamera",
		blanket.position, Vector2.DOWN)
