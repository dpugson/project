extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var topSP = $topSP
onready var bottomSP = $bottomSP
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var camera = $PuppyCamera

func _ready():
	var player_position = bottomSP.global_position
	var orientation = Vector2.UP
	Jukebox.play_song("res://tunes/forest/sunny_morning.wav")
	match stats.spawn_metadata:
		"top":
			player_position = topSP.global_position
			orientation = Vector2.DOWN
		"bottom":
			player_position = bottomSP.global_position
			orientation = Vector2.UP
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)

onready var otterbear = $YSort/otterbear
func init_otter():
	var dialogue = {
		"begin" : [
			"TEXT", "I'm excited for these FINE PASTRIES...", 
			otterbear.SPEED, null, null, otterbear.WORRIED, otterbear.PITCH
		]
	}
	otterbear.set_dialogue(dialogue, [otterbear, "left"])

func _on_topTZ_transition_triggered():
	Transition.go_to("res://Levels/9.0 - Grand Hotel/hotel_balcony.tscn", "top")

