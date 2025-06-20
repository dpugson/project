extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

onready var bottomSP = $BottomSP

func _ready():
	var player_position = player.position
	var orientation = Vector2.DOWN
	Jukebox.play_song("res://tunes/forest/starswaltz_slow.wav")
	match stats.spawn_metadata:
		"bottom":
			player_position = bottomSP.position
			orientation = Vector2.UP
		_:
			player_position = bottomSP.position
			orientation = Vector2.UP
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)


func _on_SeenBox_seen(_obj):
	var dialogue = {
		"begin" : [
			"TEXT", "The old one mumbles in their sleep...", 0.03, 
			"2", null, null, null
		],
		"2" : [
			"TEXT", "\"...potatoes...\"", 0.06, 
			null, null, null, 0.8, "meh"
		],
	}
	DialogueHelper.showDialogue(self, dialogue, true, null)

