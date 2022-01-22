extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var leftSP = $LeftSP
onready var rightSP = $RightSP
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var camera = $PuppyCamera
onready var cutscene_remote_transform = $BGStuff/AnimationPlayer/CutsceneRT
onready var animation = $BGStuff/AnimationPlayer
onready var robot = $YSort/RobotFollower
onready var animation_robot = $BGStuff/leave_robot_gorup/RobotForAnimation
onready var tictactoe = $BGStuff/TicTacToeBoard

func _ready():
	var player_position = leftSP.global_position
	var orientation = Vector2.RIGHT
	#Jukebox.play_song("res://tunes/forest/forest_theme_lofi.wav")
	match stats.spawn_metadata:
		"left":
			player_position = leftSP.global_position
			orientation = Vector2.RIGHT
		"right":
			player_position = rightSP.global_position
			orientation = Vector2.LEFT
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)

func clear_focus():
	camera.smoothing_speed = 1
	cutscene_remote_transform.remote_path = ""
	if player.remote_transform != null:
		player.remote_transform.remote_path = ""

func give_cutscene_focus():
	clear_focus()
	cutscene_remote_transform.remote_path = "../../../PuppyCamera"

func give_player_focus():
	clear_focus()
	camera.smoothing_speed = 5
	player.remote_transform.remote_path = "../../../PuppyCamera"

func what_an_astonishing_find():
	player.cutscene_mode = true
	Jukebox.play_song("res://tunes/puzzletime.wav", 1.5)
	#Jukebox.play_song("res://tunes/AncientPuzzle.wav", 1.5)
	var dialogue = {
		"begin" : [
				"TEXT", "OH! MY! GOODNESS!!!", robot.SPEED, 
				null, null, null, robot.PITCH
		],
	}
	DialogueHelper.showDialogue(self, dialogue, false, [self, "approach"])

func approach():
	animation.play("approach")

func cutscene_part5():
	var dialogue = {
		"begin" : [
				"TEXT", "Can it be??", robot.SPEED, 
				"4", null, null, robot.PITCH
		],
		"4" : [
				"TEXT", "These characteristic markings...\nThe unmistakable construction...", robot.SPEED, 
				"5", null, null, robot.PITCH
		],
		"4.5" : [
				"TEXT", "The unmistakable construction...", robot.SPEED, 
				"5", null, null, robot.PITCH
		],
		"5" : [
				"TEXT", "This is an ancient puzzle monolith from\nPuzzle Culture Linear 3!!!", robot.SPEED, 
				"6", null, null, robot.PITCH
		],
		"6" : [
				"TEXT", "To think... That such a priceless treasure was\njust outside the lab the entire time!!!", robot.SPEED, 
				"7.2", null, null, robot.PITCH
		],
		"7" : [
				"TEXT", "Oh!!! The mysteries!!!", robot.SPEED, 
				"7.1", null, null, robot.PITCH
		],
		"7.1" : [
				"TEXT", "The wonders!!!", robot.SPEED, 
				"7.2", null, null, robot.PITCH
		],
		"7.2" : [
				"TEXT", "The historiographical considerations!!!", robot.SPEED, 
				"8", null, null, robot.PITCH
		],
		"8": [
				"TEXT", "...Though, of course, it needs to be Scientifically Excavated...", robot.SPEED, 
				null, null, null, robot.PITCH
		],
	}
	DialogueHelper.showDialogue(self, dialogue, false, [self, "look_down"])

func look_down():
	animation.play("lookdown")

func shouldnttouchbut():
	var dialogue = {
		"begin" : [
				"TEXT", "...but it couldn't hurt to do a little preliminary investigation, right?", robot.SPEED, 
				[["bark!", "2"], ["bark!", "2"]], null, null, robot.PITCH
		],
		"2" : [
				"TEXT", "My thoughts exactly!!!!", robot.SPEED, 
				"3", null, null, robot.PITCH
		],
		"3" : [
				"TEXT", "Oh ho ho ho! I'm so excited!!!", robot.SPEED, 
				null, [animation_robot, "up"], null, robot.PITCH
		],
	}
	DialogueHelper.showDialogue(self, dialogue, false, [self, "start_playing"])

func start_playing():
	play_game()

var game_index = 0
func play_game():
	match game_index:
		0:
			var dialogue = {
				"begin" : [
						"TEXT", "Hmm... let's see...", robot.SPEED, 
						"2", null, null, robot.PITCH
				],
				"2" : [
						"TEXT", "What if I do...", robot.SPEED, 
						"3", null, null, robot.PITCH
				],
				"3" : [
						"TEXT", "This!", robot.SPEED, 
						null, [animation_robot, "up"], null, robot.PITCH
				],
			}
			game_index = "OHO"
			DialogueHelper.showDialogue(self, dialogue, false, [self, "push_button"])
		"OHO":
			tictactoe.increment_game()
			var dialogue = {
				"begin" : [
						"TEXT", "OHO!", robot.SPEED, 
						"2", null, null, robot.PITCH
				],
				"2" : [
						"TEXT", "An 'X'...", robot.SPEED, 
						"3", null, null, robot.PITCH
				],
				"3" : [
						"TEXT", "Fascinating...", robot.SPEED, 
						null, [animation_robot, "up"], null, robot.PITCH
				],
			}
			game_index = "an_o"
			DialogueHelper.showDialogue(self, dialogue, false, [self, "spin"])
		"an_o":
			var dialogue = {
				"begin" : [
						"TEXT", "OH MY GOODNESS!!!", robot.SPEED, 
						"2", null, null, robot.PITCH
				],
				"2" : [
						"TEXT", "The puzzle responds!!!", robot.SPEED, 
						"3", null, null, robot.PITCH
				],
				"3" : [
						"TEXT", "What does it mean?!", robot.SPEED, 
						"4", null, null, robot.PITCH
				],
				"4" : [
						"TEXT", "I wonder...", robot.SPEED, 
						null, null, null, robot.PITCH
				],
			}
			game_index = "next_move"
			DialogueHelper.showDialogue(self, dialogue, false, [self, "push_button"])
		"next_move":
			tictactoe.increment_game()
			var dialogue = {
				"begin" : [
						"TEXT", "Let's see what it does next...", robot.SPEED, 
						null, null, null, robot.PITCH
				],
			}
			game_index = "OHNO"
			DialogueHelper.showDialogue(self, dialogue, false, [self, "spin"])
		"OHNO":
			var dialogue = {
				"begin" : [
						"TEXT", "AH!", robot.SPEED, 
						"1", null, null, robot.PITCH
				],
				"1" : [
						"TEXT", "I see!!!", robot.SPEED, 
						"2", null, null, robot.PITCH
				],
				"2" : [
						"TEXT", "It appears to be going for three in a row...", robot.SPEED, 
						"3", null, null, robot.PITCH
				],
				"3" : [
						"TEXT", "But that means-\nI'm about to lose!!!", robot.SPEED, 
						null, null, null, robot.PITCH
				],
			}
			game_index = "quick_response"
			DialogueHelper.showDialogue(self, dialogue, false, [self, "push_button"])
		"quick_response":
			tictactoe.increment_game()
			var dialogue = {
				"begin" : [
						"TEXT", "Phew!! There we go...", robot.SPEED, 
						null, null, null, robot.PITCH
				],
			}
			game_index = "OHNO2"
			DialogueHelper.showDialogue(self, dialogue, false, [self, "spin"])
		"OHNO2":
			var dialogue = {
				"begin" : [
						"TEXT", "HEH!", robot.SPEED, 
						"1", null, null, robot.PITCH
				],
				"1" : [
						"TEXT", "FOOLISH PUZZLE!!!", robot.SPEED, 
						"2", null, null, robot.PITCH
				],
				"2" : [
						"TEXT", "VICTORY IS MINE!!!", robot.SPEED, 
						null, null, null, robot.PITCH
				],
			}
			game_index = "Iwin"
			DialogueHelper.showDialogue(self, dialogue, false, [self, "push_button"])
		"Iwin":
			tictactoe.increment_game()
			var dialogue = {
				"begin" : [
						"TEXT", "I WIN!!!", robot.SPEED, 
						null, null, null, robot.PITCH
				],
			}
			game_index = "over"
			DialogueHelper.showDialogue(self, dialogue, false, [self, "fall"])
		_:
			pass

func push_button():
	animation.play("push_button")

func spin():
	animation.play("spin_around")

func fall():
	animation.play("fall")

func stop_tunes():
	Jukebox.stop()

func oh_bother():
	var dialogue = {
		"begin" : [
				"TEXT", "...oh!", robot.SPEED, 
				null, null, null, robot.PITCH
		],
	}
	DialogueHelper.showDialogue(self, dialogue, false, [self, "fall2"])

func fall2():
	animation.play("fall2")

func resume():
	stats.set_bool("ROBOT_FELL")
	player.cutscene_mode = false
	give_player_focus()

func _on_LeftTZ_transition_triggered():
	Transition.go_to("res://Levels/2.0 - Forest/OutsideLab_01.tscn", "right")

func _on_RightTZ_transition_triggered():
	Transition.go_to("res://Levels/2.0 - Forest/Tangle.tscn", "bottom")
