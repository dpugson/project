extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var topSP = $topSP
onready var bottomSP = $bottomSP
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var cutscene_animation = $CutsceneAnimation
onready var robot_remote_transform = $YSort/robot/RemoteTransform2D
onready var camera = $PuppyCamera
onready var robot = $YSort/robot
onready var thesis = $YSort/Thesis
onready var save_star = $SaveStar

const EffectHelper = preload("res://effects/EffectHelper.gd")

var ROBOT_PITCH = 2
var ROBOT_SPEECH_SPEED = 0.05

func _ready():
	var player_position = bottomSP.global_position
	var orientation = Vector2.UP
	Jukebox.stop()
	#Jukebox.play_song("res://tunes/lab/background_science.wav")
	#stats.spawn_metadata = "cutscene"
	match stats.spawn_metadata:
		"bottom":
			player_position = bottomSP.global_position
			orientation = Vector2.UP
		"top":
			player_position = topSP.global_position
			orientation = Vector2.DOWN
		"cutscene":
			stats.spawn_player(
				player, null, 
				"../../../PuppyCamera", player_position, orientation)
			player.cutscene_mode = true
			player.visible = false
			cutscene_animation.play("dropoff")
			return
		"The Lab - The Final Room":
			player_position = save_star.position
			orientation = Vector2.LEFT
		"beat_game":
			stats.spawn_player(
				player, null, 
				"../../../PuppyCamera", player_position, orientation)
			player.cutscene_mode = true
			player.visible = false
			cutscene_animation.play("beat game")
			give_robot_focus()
			#Jukebox.play_song("res://tunes/lab/background_science.wav")
			return
	if stats.check_bool("ROBOT_POUTING"):
		cutscene_animation.play("pouting")
	if stats.check_bool("THESIS_DROPPED") and not stats.check_bool("THESIS_GRABBED"):
		thesis.visible = true;
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)

func give_robot_focus():
	if player.remote_transform != null:
		camera.smoothing_speed = 1
		player.remote_transform.remote_path = ""
	robot_remote_transform.remote_path = "../../../PuppyCamera"

func give_player_focus():
	player.remote_transform.remote_path = "../../../PuppyCamera"
	robot_remote_transform.remote_path = ""

func dropoff():
	var dialogue = {
		"begin" : [
			"TEXT", "Ok Doggy- PLEASE behave.", ROBOT_SPEECH_SPEED, 
			"begin2", null, null, ROBOT_PITCH
		],
		"begin2" : [
			"TEXT", "I'm sorry I can't play with you right now.", ROBOT_SPEECH_SPEED, 
			"2", null, null, ROBOT_PITCH
		],
		"2" : [
			"TEXT", "It's just, I *need* to get this work done...", ROBOT_SPEECH_SPEED, 
			"3", null, null, ROBOT_PITCH
		],
		"3" : [
			"TEXT", "You see, I'm working on an important science paper...", ROBOT_SPEECH_SPEED, 
			"4", null, null, ROBOT_PITCH
		],
		"4" : [
			"TEXT", "My thesis!", ROBOT_SPEECH_SPEED, 
			"5", null, null, ROBOT_PITCH
		],
		"5" : [
			"TEXT", "I've been working on it for 1342 years.", ROBOT_SPEECH_SPEED, 
			"6", null, null, ROBOT_PITCH
		],
		"6" : [
			"TEXT", "I just need to... Do a little more work and...", ROBOT_SPEECH_SPEED, 
			"7", null, null, ROBOT_PITCH
		],
		"7" : [
			"TEXT", "...and... and...", ROBOT_SPEECH_SPEED, 
			"8", null, null, ROBOT_PITCH
		],
		"8" : [
			"TEXT", "......", ROBOT_SPEECH_SPEED, 
			"9", null, null, ROBOT_PITCH
		],
		"9" : [
			"TEXT", "I really am just a worthless hack\naren't I...", ROBOT_SPEECH_SPEED, 
			"10", null, null, ROBOT_PITCH
		],
		"10" : [
			"TEXT", "...", ROBOT_SPEECH_SPEED, 
			null, null, null, ROBOT_PITCH
		]
	}
	DialogueHelper.showDialogue(self, dialogue, false, [self, "throw_thesis"])

func throw_thesis():
	cutscene_animation.play("throw_away_thesis")

func thesis_thrown():
	stats.world_state["THESIS_DROPPED"] = true
	give_robot_focus()
	cutscene_animation.play("pout")

func pouting_in_progress():
	stats.world_state["ROBOT_POUTING"] = true
	var dialogue = {
		"begin" : [
			"TEXT", "I'm just going to sit here until I die.", ROBOT_SPEECH_SPEED, 
			"c", null, null, ROBOT_PITCH
		],
		"c" : [
			"TEXT", "Feel free to burn down the lab or whatever.", ROBOT_SPEECH_SPEED, 
			null, null, null, ROBOT_PITCH
		],
	}
	DialogueHelper.showDialogue(self, dialogue, false, [self, "cutscene_over"])

func cutscene_over():
	give_player_focus()
	player.cutscene_mode = false

func _on_SinkSeenBox_seen(_obj):
	DialogueHelper.showDialogueSimple(self, [
		"Drip drip drip."
	], 0.05, null, true)


func _on_DeskSeenBox_seen(obj):
	DialogueHelper.showDialogueSimple(self, [
		"The notebook is entirely filled with frowny faces...",
		":( :( :( :( :( :( :( :(\n:( :( :( :( :( :( :( :("
	], 0.05, null, true)

func take_thesis():
	stats.inventory_add('thesis')
	stats.world_state["THESIS_GRABBED"] = true
	thesis.queue_free()

func lose_thesis():
	stats.inventory_remove('thesis')

func _on_ThesisSeenBox_seen(obj):
	if stats.check_bool("THESIS_GRABBED"):
		return
	var dialogue = {
		"begin" : [
			"TEXT", "Take the thesis?", 0.05, 
			[["Yes", "c"], ["No", null]], null, null, null
		],
		"c": [
			"TEXT", "Paper acquired.", 0.05, 
			null, [self, "take_thesis"], null, null
		],
	}
	DialogueHelper.showDialogue(self, dialogue)

func _on_ChemistrySeenBox_seen(obj):
	DialogueHelper.showDialogueSimple(self, [
		"A master piece in blown glass."
	], 0.05)

func _on_RedBookSeenBox_seen(obj):
	DialogueHelper.showDialogueSimple(self, [
		"The book is filled with complicated equations..."
	], 0.05)

func _on_ComputerSeenBox_seen(obj):
	DialogueHelper.showDialogueSimple(self, [
		"It looks like the computer is open to the Robot Dating website 'Short Circuit'."
	], 0.05)


func _on_RobotSeenBox_seen(obj):
	if stats.inventory_get('thesis') >= 1:
		var dialogue = {
			"begin" : [
				"TEXT", "Give the robot the thesis?", 0.05, 
				[["Give", "c"], ["Keep", null]], null, null, null
			],
			"c": [
				"TEXT", "(Have you saved? I might save now, if I were you...)", 0.05, 
				[["No", null], ["Yes", "c2"]], null, null, null
			],
			"c2": [
				"TEXT", "...", 0.05, 
				null, [self, "go_to_boss_fight"], null, null
			],
		}
		DialogueHelper.showDialogue(self, dialogue)
	else:
		DialogueHelper.showDialogueSimple(self, [
		"..."
		], 0.05)

func go_to_boss_fight():
	lose_thesis()
	Transition.go_to("res://MiniGames/battles/robot/RobotBossFight.tscn", "cutscene")


func _on_BlueBookSeenBox_seen(obj):
	DialogueHelper.showDialogueSimple(self, [
		"Sliding Puzzles: Fun or Lame? A Computational Study."
	], 0.05)

func laughing():
	stats.set_bool("ROBOT_POUTING", false)
	var dialogue = {
		"begin" : [
			"TEXT", "..........", ROBOT_SPEECH_SPEED, 
			"c", null, null, ROBOT_PITCH
		],
		"c" : [
			"TEXT", "hahahaha!!!!", ROBOT_SPEECH_SPEED, 
			"ca", null, null, ROBOT_PITCH
		],
		"ca" : [
			"TEXT", "ha ha ha!!!", ROBOT_SPEECH_SPEED, 
			"cb", null, null, ROBOT_PITCH
		],
		"cb" : [
			"TEXT", "HEE HEE!!!", ROBOT_SPEECH_SPEED, 
			"c2", null, null, ROBOT_PITCH
		],
		"c2" : [
			"TEXT", "Oh puppy!!!!", ROBOT_SPEECH_SPEED, 
			"c3", null, null, ROBOT_PITCH
		],
		"c3" : [
			"TEXT", "Thank you!!!!!!", ROBOT_SPEECH_SPEED, 
			"c4", null, null, ROBOT_PITCH
		],
		"c4" : [
			"TEXT", "My apologies... I don't know what got into me!", ROBOT_SPEECH_SPEED, 
			"c5", null, null, ROBOT_PITCH
		],
		"c5" : [
			"TEXT", "You know what! I'm going to take a break!", ROBOT_SPEECH_SPEED, 
			"c6", null, null, ROBOT_PITCH
		],
		"c6" : [
			"TEXT", "Let's figure out how to get you home...", ROBOT_SPEECH_SPEED, 
			null, null, null, ROBOT_PITCH
		],
	}
	DialogueHelper.showDialogue(self, dialogue, false, [self, "move_on_out"])

func move_on_out():
	cutscene_animation.play("move_on_out")

func done_with_cutscene():
	Transition.go_to("res://Levels/1.0 - Lab/GiftShop.tscn", "cutscene")

func _on_bottomTZ_transition_triggered():
	Transition.go_to("res://Levels/1.0 - Lab/labpuzzleroom2.tscn", "top")


func _on_topTZ_transition_triggered():
	Transition.go_to("res://Levels/1.0 - Lab/GiftShop.tscn", "bottom")

