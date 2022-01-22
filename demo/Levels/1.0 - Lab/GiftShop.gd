extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var bottomSP = $BottomSP
onready var topSP = $TopSP
onready var animation = $AnimationPlayer
onready var save_star = $SaveStar
onready var robot_remote_transform = $YSort/Robot/RemoteTransform2D
onready var camera = $PuppyCamera

onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

var ROBOT_PITCH = 2
var ROBOT_SPEECH_SPEED = 0.05

func _ready():
	stats.set_bool("alllabpuzzlesdone")
	var player_position = player.position
	var orientation = Vector2.UP
	Jukebox.play_song("res://tunes/lab/background_science.wav")
	#stats.spawn_metadata = "cutscene"
	if stats.check_bool("at_door"):
		animation.play("at_door")
	match stats.spawn_metadata:
		"The Lab - The Gift Shop":
			player_position = save_star.position
			orientation = Vector2.LEFT
		"cutscene":
			stats.spawn_player(
				player, null, 
				"../../../PuppyCamera", player_position, orientation)
			player.cutscene_mode = true
			player.visible = false
			animation.play("dropoff")
			return
		"bottom":
			player_position = bottomSP.position
			orientation = Vector2.UP
		"top":
			player_position = topSP.position
			orientation = Vector2.DOWN
		_:
			player_position = bottomSP.position
			orientation = Vector2.UP
	if stats.get("ROBOT_SHOP_STATE") == "initial_phonecall":
		animation.play("atphone")
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)

func drop_off_puppy_talk():
	var dialogue = {
		"begin" : [
			"TEXT", "Alright, then!", ROBOT_SPEECH_SPEED, 
			"2", null, null, ROBOT_PITCH
		],
		"2" : [
			"TEXT", "Follow me!", ROBOT_SPEECH_SPEED, 
			null, null, null, ROBOT_PITCH
		]
	}
	DialogueHelper.showDialogue(self, dialogue, false, [self, "go_to_door"])
	give_robot_focus()

func go_to_door():
	animation.play("go_to_door")

func done_with_cutscene():
	player.cutscene_mode = false
	give_player_focus()

func give_robot_focus():
	if player.remote_transform != null:
		camera.smoothing_speed = 1
		player.remote_transform.remote_path = ""
	robot_remote_transform.remote_path = "../../../PuppyCamera"

func give_player_focus():
	camera.smoothing_speed = 1
	player.remote_transform.remote_path = "../../../PuppyCamera"
	robot_remote_transform.remote_path = ""

func _on_RobotSeenBox_seen(_obj):
	var dialogue = {
		"begin" : [
			"TEXT", "GOOD DOG!!!!", ROBOT_SPEECH_SPEED, 
			"2", null, null, ROBOT_PITCH
		],
		"2": [
			"TEXT", "Are you ready to go for a walk?", ROBOT_SPEECH_SPEED, 
			[["No", "no"], ["Yes", "yes"]], null, null, ROBOT_PITCH
		],
		"yes": [
			"TEXT", "Alrighty then!!! Let's go!!!", ROBOT_SPEECH_SPEED, 
			"yes2", null, null, ROBOT_PITCH
		],
		"yes2": [
			"TEXT", "", ROBOT_SPEECH_SPEED, 
			null, [self, "go_on_walk"], null, null
		],
		"no": [
			"TEXT", "Ok! No worries... Take your time.", ROBOT_SPEECH_SPEED, 
			null, null, null, ROBOT_PITCH
		],
	}
	DialogueHelper.showDialogue(self, dialogue)

func go_on_walk():
	stats.set_bool("robot_following")
	stats.set_bool("left_lab")
	stats.set_bool("at_door", false)
	Transition.go_to("res://Levels/2.0 - Forest/OutsideLab_01.tscn", "cutscene_leaving_lab")

func _on_BottomTZ_transition_triggered():
	Transition.go_to("res://Levels/1.0 - Lab/labpuzzleroom3.tscn", "top")
	
func _on_topTZ_transition_triggered():
	Transition.go_to("res://Levels/2.0 - Forest/OutsideLab_01.tscn", "lab")

func walked_to_door():
	var dialogue = {
		"begin" : [
			"TEXT", "Over here, puppy!!!", ROBOT_SPEECH_SPEED, 
			null, null, null, ROBOT_PITCH
		],
	}
	stats.set_bool("at_door")
	DialogueHelper.showDialogue(self, dialogue, false, [self, "done_with_cutscene"])
