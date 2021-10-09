extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var bottomSP = $BottomSP
onready var topSP = $TopSP
onready var animation = $AnimationPlayer
onready var save_star = $SaveStar

onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

var ROBOT_PITCH = 2
var ROBOT_SPEECH_SPEED = 0.05

func _ready():
	stats.set_bool("alllabpuzzlesdone")
	var player_position = player.position
	var orientation = Vector2.UP
	#stats.spawn_metadata = "cutscene"
	match stats.spawn_metadata:
		"The Lab - The Gift Shop":
			player_position = save_star.position
			orientation = Vector2.LEFT
		"cutscene":
			Jukebox.play_song("res://tunes/lab/background_science.wav")
			stats.spawn_player(
				player, null, 
				"../../../PuppyCamera", player_position, orientation)
			player.cutscene_mode = true
			player.visible = false
			animation.play("dropoff")
			return
		"bottom":
			Jukebox.play_song("res://tunes/lab/background_science.wav")
			player_position = bottomSP.position
			orientation = Vector2.UP
		"top":
			Jukebox.play_song("res://tunes/lab/background_science.wav")
			player_position = topSP.position
			orientation = Vector2.DOWN
		_:
			Jukebox.play_song("res://tunes/lab/background_science.wav")
			player_position = bottomSP.position
			orientation = Vector2.UP
	if stats.check_bool("ROBOT_AT_PHONE"):
		animation.play("atphone")
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)

func drop_off_puppy_talk():
	var dialogue = {
		"begin" : [
			"TEXT", "Ok! I'm gonna get on the phone and make a quick call.", ROBOT_SPEECH_SPEED, 
			"c", null, null, ROBOT_PITCH
		],
		"c" : [
			"TEXT", "Feel free to explore!", ROBOT_SPEECH_SPEED, 
			null, null, null, ROBOT_PITCH
		],
	}
	DialogueHelper.showDialogue(self, dialogue, false, [self, "make_a_call"])

func make_a_call():
	animation.play("gophone")

func start_talking_on_phone():
	var dialogue = {
		"begin" : [
			"TEXT", "Hello? May I talk to the operator?", ROBOT_SPEECH_SPEED, 
			null, null, null, ROBOT_PITCH
		]
	}
	DialogueHelper.showDialogue(self, dialogue, false, [self, "done_with_cutscene"])

func done_with_cutscene():
	player.cutscene_mode = false
	stats.set_bool("ROBOT_AT_PHONE")


var robot_talk_index = 0
func _on_RobotSeenBox_seen(obj):
	var choices = [
		"Hmm mmm... Yup... ok!",
		"Oh, you don't say?",
		"Um- is there anyone else I can talk to?",
		"Could you say that again?"
	]
	var dialogue = choices[robot_talk_index % len(choices)]
	robot_talk_index += 1
	DialogueHelper.showDialogueSimple(self, [dialogue], ROBOT_SPEECH_SPEED, ROBOT_PITCH, true)

func _on_BottomTZ_transition_triggered():
	Transition.go_to("res://Levels/1.0 - Lab/labpuzzleroom3.tscn", "top")
	
func _on_topTZ_transition_triggered():
	Transition.go_to("res://Levels/2.0 - Forest/OutsideLab_01.tscn", "lab")
