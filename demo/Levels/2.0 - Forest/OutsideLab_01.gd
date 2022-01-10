extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var labSP = $LabSP
onready var rightSP = $RightSP
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var camera = $PuppyCamera
onready var robot = $YSort/RobotFollower
onready var animation = $AnimationPlayer

func _ready():
	var player_position = labSP.global_position
	var orientation = Vector2.RIGHT
	Jukebox.play_song("res://tunes/forest/forest_theme_lofi.wav")
	#stats.spawn_metadata = "cutscene_leaving_lab"
	match stats.spawn_metadata:
		"cutscene_leaving_lab":
			player_position = labSP.global_position
			orientation = Vector2.RIGHT
			cutscene_leaving_lab()
		"lab":
			player_position = labSP.global_position
			orientation = Vector2.RIGHT
		"right":
			player_position = rightSP.global_position
			orientation = Vector2.DOWN
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)

func cutscene_leaving_lab():
	animation.play("cutscene_leaving_lab")

func admire_beauty():
	var dialogue = {
		"begin" : [
			"TEXT", "Wow...", robot.SPEED, 
			"2", null, null, robot.PITCH
		],
		"2" : [
			"TEXT", "What a beautiful day!!!", robot.SPEED, 
			"3", null, null, robot.PITCH
		],
		"3" : [
			"TEXT", "The crisp air!!! The colorful leaves!!!", robot.SPEED, 
			"4", null, null, robot.PITCH
		],
		"4" : [
			"TEXT", "This is the first time I've left the lab in decades...\nIt's refreshing!", robot.SPEED, 
			null, null, null, robot.PITCH
		],
	}
	DialogueHelper.showDialogue(self, dialogue, false, [self, "done_with_cutscene"])

func _on_PuzzleHouseTZ_transition_triggered():
	Transition.go_to("res://Levels/1.0 - Lab/GiftShop.tscn", "top")

func _on_RightTZ_transition_triggered():
	Transition.go_to("res://Levels/2.0 - Forest/OutsideLab_02.tscn", "left")

func _on_TopTZ_transition_triggered():
	pass # Replace with function body.
