extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var bottomSP = $bottomSP
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var camera = $PuppyCamera

func _ready():
	var player_position = bottomSP.global_position
	var orientation = Vector2.UP
	Jukebox.play_song("res://tunes/deserted_town_instrumental.wav")
	match stats.spawn_metadata:
		"bottom":
			player_position = bottomSP.global_position
			orientation = Vector2.UP
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)


func _on_bottomTZ_transition_triggered():
	Transition.go_to("res://Levels/2.0 - Forest/town/mayors_house/mayors_house_lower_room.tscn", "top")


func _on_SeenBox_seen(obj):
	var dialogue = {
		"begin" : [
			"TEXT", "The old one mumbles in their sleep...", 0.03, 
			"2", null, null, null
		],
		"2" : [
			"TEXT", "...All gone...", 0.06, 
			"3", null, null, 0.8, "meh"
		],
		"3" : [
			"TEXT", "...Just me left...", 0.06, 
			null, null, null, 0.8, "meh"
		],
	}
	DialogueHelper.showDialogue(self, dialogue, false, null)

