extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

onready var rightSP = $RightSP

func _ready():
	var player_position = player.position
	var orientation = Vector2.DOWN
	Jukebox.play_song("res://Levels/21.0 Train/train_car/train_ride.wav")
	match stats.spawn_metadata:
		"right":
			player_position = rightSP.position
			orientation = Vector2.LEFT
		_:
			player_position = rightSP.position
			orientation = Vector2.UP
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)

func _on_BottomTZ_transition_triggered():
	pass # Replace with function body.

func _on_SeenBox_seen(_obj):
	var dialogue = {
		"begin" : [
			"TEXT", "???XN?C??ZNC?Z?!!", 0.03, 
			"2", null, null, 0.8, "meh"
		],
		"2" : [
			"TEXT", "XBLBVBLBFLBLAB???", 0.06, 
			 [["yes please!", "3"], ["no thank you", "3"]],
			null, null, 0.8, "meh"
		],
		"3" : [
			"TEXT", "OUBWRBZ>ZXZCZC!", 0.06, 
			null, null, null, 0.8, "meh"
		],
	}
	DialogueHelper.showDialogue(self, dialogue, false, null)


func _on_LeafbertSeenBox_seen(_obj):
	var dialogue = {
		"begin" : [ 
			"TEXT", "WHOAH!!! THE SUGAR RUSH IS REAL!!!",
			0.02, "next", null, null, 1.5],
		"next" : [
			"TEXT", "THIS FEELS CRAZY!!!",
			0.02, null, null, null, 1.2],
	}
	DialogueHelper.showDialogue(self, dialogue, false, null)

func _on_LeafsonSeenBox_seen(_obj):
	var dialogue = {
		"begin" : [
			"TEXT", "SUGAR SUGAR SUGAR!!!\nIF I EAT ANY MORE SWEETS I'M GONNA SNAP!!!",
			0.02, null, null, null, 1.2],
	}
	DialogueHelper.showDialogue(self, dialogue, false, null)


func _on_TableSeenBox_seen(_obj):
	var dialogue = {
		"begin" : [
			"TEXT", "A veritable symphony of sweets.",
			0.02, null, null, null, null]
	}
	DialogueHelper.showDialogue(self, dialogue, false, null)
