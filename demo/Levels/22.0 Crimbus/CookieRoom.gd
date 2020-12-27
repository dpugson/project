extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var animation = $AnimationPlayer

onready var bottomSP = $BottomSP

const COOKIE_JAR_FELL = "COOKIE_JAR_FELL"
var ROBOT_PITCH = 2
var ROBOT_SPEECH_SPEED = 0.05
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

func _ready():
	Jukebox.play_song("res://tunes/crimbus/crimmas.wav")
	var player_position = bottomSP.position
	var orientation = Vector2.UP
	
	if stats.check_bool(COOKIE_JAR_FELL):
		animation.play("got_cookies")
	
	match stats.spawn_metadata:
		"bottom":
			player_position = bottomSP.position
			orientation = Vector2.UP
		_:
			pass
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)

func _on_TransitionZone_transition_triggered():
	Transition.go_to("res://Levels/22.0 Crimbus/BigRoom.tscn", "pantry")
	 
func _on_StaticBody2D_slammed():
	if !stats.check_bool(COOKIE_JAR_FELL):
		animation.play("fall")
		stats.world_state[COOKIE_JAR_FELL] = true

func play_yay_dialogue():
	var dialogue = {
			"begin" : [
				"TEXT", "HURRAY!!!", ROBOT_SPEECH_SPEED, 
				"1", null, null, ROBOT_PITCH
			],
			"1" : [
				"TEXT", "Thank you, kindly puppy!!!", ROBOT_SPEECH_SPEED, 
				"2", null, null, ROBOT_PITCH
			],
			"2" : [
				"TEXT", "I owe you much gratitude!!! Please, have a cookie!", ROBOT_SPEECH_SPEED, 
				"3", null, null, ROBOT_PITCH
			],
		}
	DialogueHelper.showDialogue(self, dialogue)

func get_options():
	var options = []
	if not stats.check_bool("GOT_COOKIE"):
		options.append(["May I have a cookie?", "get_cookie"])
	if not stats.check_bool("GOT_COOKIE_VOTE"):
		options.append(["Will you vote for me?", "get_vote"])

func add_vote():
	var num_votes = stats.world_state .get("CRIMMAS_VOTES", 0)
	stats.world_state["CRIMMAS_VOTES"] = num_votes + 1
	
func _on_SeenBox_seen(_obj):
	var dialogue = null
	if stats.check_bool(COOKIE_JAR_FELL):
		dialogue = {
			"begin" : [
				"TEXT", "Can't... reach... :(", ROBOT_SPEECH_SPEED, 
				null, null, null, ROBOT_PITCH
			],
		}
	else:
		dialogue = {
			"begin" : [
				"TEXT", "Hi puppy!!!", ROBOT_SPEECH_SPEED, 
				null, null, null, ROBOT_PITCH
			],
			"get_cookie" : [
				"TEXT", "Here you go!", ROBOT_SPEECH_SPEED, 
				"get_cookie2", null, null, ROBOT_PITCH
			],
			"get_cookie2" : [
				"TEXT", "You download ONE COOKIE into your mind vault.", ROBOT_SPEECH_SPEED, 
				null, null, null, ROBOT_PITCH
			],
			"get_vote" : [
				"TEXT", "OF COURSE!", ROBOT_SPEECH_SPEED, 
				"gv2", null, null, ROBOT_PITCH
			],
			"gv2" : [
				"TEXT", "You have securied 1 VOTE.", ROBOT_SPEECH_SPEED, 
				null, [self, "add_vote"], null
			],
		}
	DialogueHelper.showDialogue(self, dialogue)
