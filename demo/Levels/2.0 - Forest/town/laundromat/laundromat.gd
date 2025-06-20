extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var registerSounds = $register

onready var bottomSP = $BottomSP

func _ready():
	var player_position = player.position
	var orientation = Vector2.DOWN
	Jukebox.play_song("res://Levels/2.0 - Forest/town/laundromat/ninja_laundromat_crunchy.wav")
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

func _on_BottomTZ_transition_triggered():
	pass # Replace with function body.

func _on_RegisterSeenBox_seen(_obj):
	DialogueHelper.showDialogue(self, {
	"begin" : [
		"ACTION", "Kaching!!!", 0.03, null,
		[self, "kaching", null], null, null
	],
	}, true)

func kaching(_args):
	registerSounds.play()
